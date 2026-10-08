// delivery details from checkout step 2
// same fields as orders.deliveryAddress and users.defaultDeliveryAddress
class DeliveryDetails {
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String district;

  const DeliveryDetails({
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.district,
  });

  Map<String, dynamic> toMap() => {
        'recipientName': recipientName,
        'phone': phone,
        'addressLine': addressLine,
        'city': city,
        'district': district,
      };
}
