import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DeliveryAddressCard extends StatelessWidget {
  final String address;
  final String phone;
  final VoidCallback onEdit;

  const DeliveryAddressCard({
    Key? key,
    required this.address,
    required this.phone,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Shipping Destination',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Change',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address.isNotEmpty ? address : 'Please enter your delivery address in Sri Lanka',
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Contact: $phone', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}
