import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../data/buy_now_request.dart';
import '../../data/delivery_details.dart';
import '../state/cart_provider.dart';
import '../state/checkout_provider.dart';
import '../widgets/order_text.dart';
import '../widgets/purchase_parts.dart';
import 'order_failed_screen.dart';
import 'order_placed_screen.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I07 Checkout (hi-fi HF3 - HF8)
// from the cart it buys all cart items, from Buy Now only that product
class CheckoutScreen extends StatefulWidget {
  final BuyNowRequest? buyNow;

  const CheckoutScreen({super.key, this.buyNow});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _checkout = CheckoutProvider();
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _note = TextEditingController();

  bool _showErrors = false;
  Map<String, dynamic>? _savedAddress;
  // keep the items while placing, so the screen doesn't change when the cart is cleared
  List<OrderItemModel>? _placingItems;

  @override
  void initState() {
    super.initState();
    try {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        _name.text = user.displayName;
        _phone.text = user.phone ?? '';
        _savedAddress = user.defaultDeliveryAddress;
        _useSavedAddress();
      }
    } on ProviderNotFoundException {
      // no account in widget tests
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _street, _city, _district, _note]) {
      c.dispose();
    }
    _checkout.dispose();
    super.dispose();
  }

  void _useSavedAddress() {
    final saved = _savedAddress;
    if (saved == null) return;
    String value(String key) => (saved[key] ?? '').toString();
    if (value('recipientName').isNotEmpty) _name.text = value('recipientName');
    if (value('phone').isNotEmpty) _phone.text = value('phone');
    _street.text = value('addressLine');
    _city.text = value('city');
    _district.text = value('district');
  }

  List<OrderItemModel> _items(BuildContext context) {
    if (_placingItems != null) return _placingItems!;
    final buyNow = widget.buyNow;
    if (buyNow != null) {
      final p = buyNow.product;
      return [
        OrderItemModel(
          productId: p.id,
          title: p.title,
          unitPriceLkr: p.priceLkr,
          quantity: buyNow.quantity,
          imageUrl: p.imageUrls.isEmpty ? null : p.imageUrls.first,
          artisanId: p.artisanId,
        ),
      ];
    }
    return context.watch<CartProvider>().cartItems;
  }

  double _subtotal(List<OrderItemModel> items) =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get _fee => CartProvider.deliveryFee;

  void _back() {
    if (_checkout.placing) return;
    if (_checkout.step > 0) {
      _checkout.goTo(_checkout.step - 1);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _continueFromDelivery() {
    final valid = _form.currentState?.validate() ?? false;
    setState(() => _showErrors = !valid);
    if (!valid) return;
    FocusScope.of(context).unfocus();
    _checkout.goTo(2);
  }

  Future<void> _place(List<OrderItemModel> items) async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final cart = widget.buyNow == null ? context.read<CartProvider>() : null;
    final placing = List<OrderItemModel>.of(items);
    setState(() => _placingItems = placing);

    final note = _note.text.trim();
    final result = await _checkout.placeOrder(
      buyerId: user.uid,
      buyerName: user.displayName,
      items: placing,
      address: DeliveryDetails(
        recipientName: _name.text.trim(),
        phone: PhoneUtils.normalize(_phone.text),
        addressLine: _street.text.trim(),
        city: _city.text.trim(),
        district: _district.text.trim(),
      ),
      deliveryFee: _fee,
      deliveryNote: note.isEmpty ? null : note,
    );
    if (!mounted) return;

    if (result.ok) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => OrderPlacedScreen(orders: result.orders),
      ));
      cart?.removeItems(placing.map((item) => item.productId));
      return;
    }

    setState(() => _placingItems = null);
    final leave = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => OrderFailedScreen(
        failure: result.failure!,
        soldOut: result.soldOut,
        items: placing,
        fromCart: widget.buyNow == null,
      ),
    ));
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context);
    return ListenableBuilder(
      listenable: _checkout,
      builder: (context, _) {
        final step = _checkout.step;
        final placing = _checkout.placing;
        return PopScope(
          canPop: step == 0 && !placing,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _back();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.tr('pur_checkout_title')),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: placing
                  ? null
                  : IconButton(
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _back,
                    ),
            ),
            body: SafeArea(
              child: placing
                  ? const _PlacingView()
                  : items.isEmpty
                      ? const _NothingToBuy()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                              child: CheckoutStepper(step: step),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: _stepBody(context, step, items),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: _stepButton(context, step, items),
                            ),
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }

  Widget _stepBody(BuildContext context, int step, List<OrderItemModel> items) {
    switch (step) {
      case 0:
        return _review(context, items);
      case 1:
        return _delivery(context);
      case 2:
        return _payment(context, items);
      default:
        return _confirm(context, items);
    }
  }

  Widget _stepButton(BuildContext context, int step, List<OrderItemModel> items) {
    final total = _subtotal(items) + _fee;
    switch (step) {
      case 0:
        return _NextButton(
            label: context.tr('pur_continue_delivery'),
            onPressed: () => _checkout.goTo(1));
      case 1:
        return _NextButton(
            label: context.tr('pur_continue_payment'),
            onPressed: _continueFromDelivery);
      case 2:
        return _NextButton(
            label: context.tr('pur_continue_confirm'),
            onPressed: () => _checkout.goTo(3));
      default:
        return ElevatedButton.icon(
          onPressed: _checkout.checked ? () => _place(items) : null,
          icon: const Icon(Icons.lock_outline, size: 18),
          label: Text(context.tr('pur_place_order',
              {'amount': CurrencyFormatter.formatLKR(total)})),
        );
    }
  }

  // ---- step 1: review (HF3) ----
  Widget _review(BuildContext context, List<OrderItemModel> items) {
    final artisans = items.map((i) => i.artisanId).toSet().length;
    return Column(
      children: [
        PurchaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('pur_order_items', {'count': '${items.length}'}),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SmallBadge(
                    text: context.tr('pur_from_workshops', {'count': '$artisans'}),
                    icon: Icons.storefront_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(height: 20),
                _ReviewLine(item: items[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        InfoNote(
          icon: Icons.verified_user_outlined,
          title: context.tr('pur_handmade_title'),
          text: context.tr('pur_handmade_text'),
        ),
        const SizedBox(height: 12),
        _SummaryCard(subtotal: _subtotal(items), fee: _fee),
      ],
    );
  }

  // ---- step 2: delivery (HF4, errors HF5) ----
  Widget _delivery(BuildContext context) {
    String? requiredField(String? v) =>
        (v == null || v.trim().isEmpty) ? context.tr('pur_err_required') : null;

    return Form(
      key: _form,
      autovalidateMode:
          _showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showErrors) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.tr('pur_fix_fields'),
                      style: const TextStyle(
                          color: AppColors.error, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('pur_shipping_address'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              if (_savedAddress != null)
                TextButton.icon(
                  onPressed: () => setState(_useSavedAddress),
                  icon: const Icon(Icons.home_outlined, size: 18),
                  label: Text(context.tr('pur_use_saved')),
                ),
            ],
          ),
          const SizedBox(height: 8),
          PurchaseCard(
            child: Column(
              children: [
                _Field(
                  label: context.tr('pur_full_name'),
                  controller: _name,
                  hint: 'Kavindu Fernando',
                  validator: requiredField,
                  capitalization: TextCapitalization.words,
                ),
                _Field(
                  label: context.tr('pur_mobile'),
                  controller: _phone,
                  hint: '077 123 4567',
                  keyboardType: TextInputType.phone,
                  validator: (v) => context.trMessage(PhoneUtils.validate(v)),
                ),
                _Field(
                  label: context.tr('pur_street'),
                  controller: _street,
                  hint: context.tr('pur_street_hint'),
                  validator: requiredField,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _Field(
                        label: context.tr('pur_city'),
                        controller: _city,
                        hint: 'Colombo 03',
                        validator: requiredField,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Field(
                        label: context.tr('pur_district'),
                        controller: _district,
                        hint: 'Colombo',
                        validator: requiredField,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                _Field(
                  label: context.tr('pur_delivery_notes'),
                  controller: _note,
                  hint: context.tr('pur_notes_hint'),
                  optional: true,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          CheckboxListTile(
            value: _checkout.saveAddress,
            onChanged: (v) => _checkout.setSaveAddress(v ?? false),
            title: Text(context.tr('pur_save_address'),
                style: const TextStyle(fontSize: 14)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          InfoNote(
            icon: Icons.inventory_2_outlined,
            title: context.tr('pur_packaging_title'),
            text: context.tr('pur_packaging_text'),
            color: AppColors.secondaryDark,
          ),
        ],
      ),
    );
  }

  // ---- step 3: payment (HF6) ----
  Widget _payment(BuildContext context, List<OrderItemModel> items) {
    final total = _subtotal(items) + _fee;
    final method = _checkout.paymentMethod;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PurchaseCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ItemThumb(imageUrl: items.first.imageUrl, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(OrderText.itemsTitle(context, items),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      context.tr('pur_order_total',
                          {'amount': CurrencyFormatter.formatLKR(total)}),
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                context.tr('pur_select_payment'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              context.tr('pur_step_of', {'step': '3', 'total': '4'}),
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _PaymentOption(
          selected: method == PaymentMethods.cashOnDelivery,
          icon: Icons.payments_outlined,
          title: context.tr('pur_pay_cod'),
          subtitle: context.tr('pur_pay_cod_sub'),
          onTap: () => _checkout.setPaymentMethod(PaymentMethods.cashOnDelivery),
        ),
        const SizedBox(height: 10),
        _PaymentOption(
          selected: method == PaymentMethods.bankTransfer,
          icon: Icons.account_balance_outlined,
          title: context.tr('pur_pay_bank'),
          subtitle: context.tr('pur_pay_bank_sub'),
          onTap: () => _checkout.setPaymentMethod(PaymentMethods.bankTransfer),
        ),
        const SizedBox(height: 14),
        InfoNote(
          icon: Icons.lock_outline,
          title: context.tr('pur_no_card_title'),
          text: context.tr('pur_no_card_text'),
        ),
      ],
    );
  }

  // ---- step 4: confirm and place (HF7) ----
  Widget _confirm(BuildContext context, List<OrderItemModel> items) {
    final subtotal = _subtotal(items);
    final count = items.fold(0, (sum, item) => sum + item.quantity);
    final artisans = items.map((i) => i.artisanId).toSet().length;
    final address = [
      _street.text.trim(),
      _city.text.trim(),
      _district.text.trim(),
    ].where((part) => part.isNotEmpty).join(', ');
    final note = _note.text.trim();

    return Column(
      children: [
        PurchaseCard(
          child: Row(
            children: [
              ItemThumb(imageUrl: items.first.imageUrl, size: 60),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallBadge(
                      text: context.tr('pur_handmade_badge'),
                      icon: Icons.verified_outlined,
                    ),
                    const SizedBox(height: 4),
                    Text(OrderText.itemsTitle(context, items),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    ArtisanLine(artisanId: items.first.artisanId, showPlace: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PurchaseCard(
          child: Column(
            children: [
              AmountRow(
                label: context.tr('pur_items_from',
                    {'items': '$count', 'artisans': '$artisans'}),
                value: CurrencyFormatter.formatLKR(subtotal),
              ),
              AmountRow(
                label: context.tr('pur_courier_delivery'),
                value: CurrencyFormatter.formatLKR(_fee),
              ),
              const Divider(height: 20),
              AmountRow(
                label: context.tr('pur_grand_total'),
                value: CurrencyFormatter.formatLKR(subtotal + _fee),
                bold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _DetailCard(
          icon: Icons.place_outlined,
          title: context.tr('pur_deliver_to'),
          actionLabel: context.tr('pur_change_address'),
          onAction: () => _checkout.goTo(1),
          lines: [
            _name.text.trim(),
            PhoneUtils.display(_phone.text),
            address,
            if (note.isNotEmpty) note,
          ],
        ),
        const SizedBox(height: 12),
        _DetailCard(
          icon: Icons.payments_outlined,
          title: context.tr('pur_payment_method'),
          actionLabel: context.tr('pur_change_payment'),
          onAction: () => _checkout.goTo(2),
          lines: [OrderText.payment(context, _checkout.paymentMethod)],
        ),
        const SizedBox(height: 12),
        InfoNote(
          icon: Icons.storefront_outlined,
          title: context.tr('pur_artisan_impact_title'),
          text: context.tr('pur_artisan_impact_text'),
        ),
        const SizedBox(height: 4),
        CheckboxListTile(
          value: _checkout.checked,
          onChanged: (v) => _checkout.setChecked(v ?? false),
          title: Text(context.tr('pur_confirm_check'),
              style: const TextStyle(fontSize: 14)),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NextButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  final OrderItemModel item;

  const _ReviewLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemThumb(imageUrl: item.imageUrl, size: 56),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.title} × ${item.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              ArtisanLine(artisanId: item.artisanId, showPlace: true),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(CurrencyFormatter.formatLKR(item.lineTotal),
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subtotal;
  final double fee;

  const _SummaryCard({required this.subtotal, required this.fee});

  @override
  Widget build(BuildContext context) {
    return PurchaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('pur_summary'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          AmountRow(
            label: context.tr('subtotal'),
            value: CurrencyFormatter.formatLKR(subtotal),
          ),
          AmountRow(
            label: context.tr('pur_courier_delivery'),
            value: CurrencyFormatter.formatLKR(fee),
            badge: SmallBadge(
              text: context.tr('pur_islandwide'),
              color: AppColors.secondaryDark,
            ),
          ),
          AmountRow(
            label: context.tr('artisan_packaging'),
            value: context.tr('pur_free'),
            valueColor: AppColors.accent,
          ),
          const Divider(height: 20),
          AmountRow(
            label: context.tr('pur_total_amount'),
            value: CurrencyFormatter.formatLKR(subtotal + fee),
            bold: true,
          ),
        ],
      ),
    );
  }
}

// text field with the label above it
class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  final bool optional;
  final int maxLines;

  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.optional = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              if (optional)
                Text(context.tr('pur_optional'),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            textCapitalization: capitalization,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// "Deliver to" / "Payment method" boxes on the confirm step
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final List<String> lines;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final shown = lines.where((line) => line.trim().isNotEmpty).toList();
    return PurchaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              TextButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ),
          for (var i = 0; i < shown.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 2),
              child: Text(
                shown[i],
                style: TextStyle(
                  fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w400,
                  color: i == 0 ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// HF8 - while the order is saving
class _PlacingView extends StatelessWidget {
  const _PlacingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmallBadge(
              text: context.tr('pur_handmade_badge'),
              icon: Icons.verified_outlined,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 104,
              height: 104,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 104,
                    height: 104,
                    child: CircularProgressIndicator(strokeWidth: 4),
                  ),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: AppColors.primary, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              context.tr('pur_placing_title'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr('pur_placing_sub'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            InfoNote(
              icon: Icons.hourglass_top_outlined,
              title: context.tr('pur_keep_open_title'),
              text: context.tr('pur_keep_open_text'),
              color: AppColors.secondaryDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _NothingToBuy extends StatelessWidget {
  const _NothingToBuy();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_basket_outlined,
                size: 64, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(context.tr('pur_nothing_to_buy'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(context.tr('pur_go_back')),
            ),
          ],
        ),
      ),
    );
  }
}
