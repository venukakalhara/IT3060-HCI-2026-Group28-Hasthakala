import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/shared_models/review_model.dart';
import '../../../../core/shared_models/user_model.dart';
import '../state/auth_provider.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_photo_picker.dart';

class BuyerAccountDetailsScreen extends StatefulWidget {
  const BuyerAccountDetailsScreen(
      {super.key, required this.user, this.address = false});
  final UserModel user;
  final bool address;
  @override
  State<BuyerAccountDetailsScreen> createState() =>
      _BuyerAccountDetailsScreenState();
}

class _BuyerAccountDetailsScreenState extends State<BuyerAccountDetailsScreen> {
  final _form = GlobalKey<FormState>();
  final Map<String, TextEditingController> _fields = {};
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    final values = widget.address
        ? {
            'recipientName': user.displayName,
            'phone': user.phone ?? '',
            'addressLine': '',
            'city': '',
            'district': '',
            ...?user.defaultDeliveryAddress
          }
        : {
            'displayName': user.displayName,
            'phone': user.phone ?? '',
          };
    for (final entry in values.entries) {
      _fields[entry.key] =
          TextEditingController(text: entry.value?.toString() ?? '');
    }
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    final values =
        _fields.map((key, value) => MapEntry(key, value.text.trim()));
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(widget.user.uid)
          .update({
        if (widget.address) 'defaultDeliveryAddress': values else ...values,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await auth.reloadCurrentUser();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              widget.address ? 'Delivery address saved' : 'Profile updated')));
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error =
              'Could not save your changes. Check your connection and try again.';
        });
      }
    }
  }

  String? _validate(String key, String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty && (widget.address || key == 'displayName')) {
      return 'This field is required';
    }
    if (key == 'phone' &&
        text.isNotEmpty &&
        !RegExp(r'^\+?[\d\s()-]{9,20}$').hasMatch(text)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.address
        ? {
            'recipientName': 'Recipient name',
            'phone': 'Phone number',
            'addressLine': 'Street address',
            'city': 'City',
            'district': 'District'
          }
        : {
            'displayName': 'Full name',
            'phone': 'Phone number (optional)',
          };
    return PopScope(
        canPop: !_saving,
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.address ? 'Saved addresses' : 'Edit profile')),
          body: Form(
              key: _form,
              child: ListView(padding: const EdgeInsets.all(20), children: [
                if (widget.address) ...[
                  const Text('Default delivery address',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text(
                      'Save the address you use most often. Confirm delivery details at checkout.'),
                  const SizedBox(height: 24),
                ],
                if (!widget.address) ...[
                  Center(
                    child: ProfileAvatarWidget(
                      uid: widget.user.uid,
                      name: widget.user.displayName,
                      imageUrl: widget.user.photoUrl,
                      radius: 52,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ProfilePhotoButton(
                      uid: widget.user.uid,
                      alignment: CrossAxisAlignment.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      widget.user.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                for (final entry in labels.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: TextFormField(
                        controller: _fields[entry.key],
                        enabled: !_saving,
                        decoration: InputDecoration(
                            labelText: entry.value, helperMaxLines: 2),
                        keyboardType: entry.key == 'phone'
                            ? TextInputType.phone
                            : TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 200,
                        validator: (value) => _validate(entry.key, value)),
                  ),
                if (_error != null)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(_error!,
                          style: const TextStyle(color: AppColors.error))),
                ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Saving…' : 'Save changes')),
              ])),
        ));
  }
}

class BuyerReviewsScreen extends StatefulWidget {
  const BuyerReviewsScreen({super.key, required this.userId});
  final String userId;
  @override
  State<BuyerReviewsScreen> createState() => _BuyerReviewsScreenState();
}

class _BuyerReviewsScreenState extends State<BuyerReviewsScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _reviews;
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _reviews = FirebaseFirestore.instance
        .collection(FirestoreCollections.reviews)
        .where('buyerId', isEqualTo: widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('My reviews')),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _reviews,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Text(
                              'Could not load your reviews. Please try again.'),
                          TextButton(
                              onPressed: () => setState(_load),
                              child: const Text('Retry')),
                        ])));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final reviews = snapshot.data!.docs
                  .map((doc) => ReviewModel.fromMap(doc.data()))
                  .toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              if (reviews.isEmpty) {
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.rate_review_outlined,
                              size: 48, color: AppColors.primary),
                          SizedBox(height: 16),
                          Text('No reviews yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Your product reviews will appear here.',
                              textAlign: TextAlign.center),
                        ])));
              }
              return ListView(padding: const EdgeInsets.all(20), children: [
                for (final review in reviews)
                  Card(
                      child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order ${review.orderId}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Semantics(
                                    label: '${review.rating} out of 5 stars',
                                    child: Row(children: [
                                      for (var i = 1; i <= 5; i++)
                                        Icon(
                                            i <= review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: AppColors.secondary,
                                            size: 20),
                                    ])),
                                if (review.comment.isNotEmpty)
                                  Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(review.comment)),
                              ]))),
              ]);
            }),
      );
}
