import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

/// High-Fidelity Custom Commission Request Screen matching Stitch Canvas specification
class CustomCommissionScreen extends StatefulWidget {
  const CustomCommissionScreen({super.key});

  @override
  State<CustomCommissionScreen> createState() => _CustomCommissionScreenState();
}

class _CustomCommissionScreenState extends State<CustomCommissionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController =
      TextEditingController(text: '5000');
  final _referenceController = TextEditingController();
  String _selectedCategory = 'Pottery & Clay';
  String _selectedArtisan = 'Sunil Kariyawasam (Kelaniya Guild)';

  @override
  void dispose() {
    _referenceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  final List<String> _categories = [
    'Pottery & Clay',
    'Woodcarving & Masks',
    'Batik & Handloom',
    'Brass & Metal Casting',
  ];

  final List<String> _artisanGuilds = [
    'Sunil Kariyawasam (Kelaniya Guild)',
    'Kamal Perera (Ambalangoda Guild)',
    'Nalini Abeyratne (Dumbara Guild)',
    'Any Available Master Artisan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Custom Commission Request',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Order Intro Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.palette_outlined,
                      color: AppColors.primary, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Commission a unique piece crafted to your exact dimensions & heritage specifications directly by master Sri Lankan artisans.',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Selection
            const Text(
              'Select Craft Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Commission Title & Details
            const Text(
              'Commission Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. 14-inch Unglazed Terracotta Water Urn',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Detailed Design & Material Requirements',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Describe dimensions, traditional motifs, raw material preferences (e.g. natural riverbank clay), and specific usage...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reference Attachment Box
            const Text(
              'Reference Photo or Sketch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
                controller: _referenceController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                    labelText: 'Reference image link (optional)',
                    hintText: 'https://...')),
            const SizedBox(height: 16),

            // Preferred Artisan Guild Selection
            const Text(
              'Preferred Master Artisan / Guild',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedArtisan,
                  isExpanded: true,
                  items: _artisanGuilds.map((artisan) {
                    return DropdownMenuItem(
                        value: artisan, child: Text(artisan));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedArtisan = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Budget Input
            const Text(
              'Estimated Target Budget (LKR)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'LKR ',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Terms & Direct Payout Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF264E36).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: const Color(0xFF264E36).withOpacity(0.2)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined,
                      color: Color(0xFF264E36), size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Prepare a request draft to share with an artisan. Copying a draft does not submit an order or take a deposit.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF264E36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  final budget = double.tryParse(_budgetController.text.trim());
                  final reference = _referenceController.text.trim();
                  final uri = Uri.tryParse(reference);
                  if (_titleController.text.trim().isEmpty ||
                      _descriptionController.text.trim().isEmpty ||
                      budget == null ||
                      !budget.isFinite ||
                      budget <= 0 ||
                      (reference.isNotEmpty &&
                          (uri == null ||
                              !['http', 'https'].contains(uri.scheme) ||
                              uri.host.isEmpty))) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Add a title, design details, positive budget and valid reference link.')));
                    return;
                  }
                  try {
                    await Clipboard.setData(ClipboardData(
                        text:
                            'Hasthakala commission draft\n${_titleController.text.trim()}\nCategory: $_selectedCategory\nArtisan preference: $_selectedArtisan\n${_descriptionController.text.trim()}\nBudget: LKR ${budget.toStringAsFixed(2)}\nReference: $reference'));
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Request draft copied. Share it with your artisan; it has not been submitted.')));
                  } catch (_) {
                    if (mounted)
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Could not copy the draft. Please try again.')));
                  }
                },
                child: const Text(
                  'Copy Request Draft',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
