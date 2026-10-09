import '../../../core/shared_models/product_model.dart';

// Buy Now on product details passes this to checkout.
// Only this product is bought, the cart is not changed.
class BuyNowRequest {
  final ProductModel product;
  final int quantity;

  const BuyNowRequest({required this.product, required this.quantity});
}
