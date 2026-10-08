import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/user_model.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../state/auth_provider.dart';
import '../widgets/role_selector_card.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AccountPurpose _selectedRole = AccountPurpose.shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Account'),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Select Account Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                RoleSelectorCard(
                  role: AccountPurpose.shop,
                  title: 'Craft Enthusiast / Buyer',
                  description: 'Discover authentic handmade items, order, and support local artisans.',
                  icon: Icons.shopping_bag_outlined,
                  isSelected: _selectedRole == AccountPurpose.shop,
                  onSelect: () => setState(() => _selectedRole = AccountPurpose.shop),
                ),
                const SizedBox(height: 10),
                RoleSelectorCard(
                  role: AccountPurpose.sell,
                  title: 'Sri Lankan Artisan / Maker',
                  description: 'Showcase your heritage craft, sell directly, and connect with buyers.',
                  icon: Icons.brush_outlined,
                  isSelected: _selectedRole == AccountPurpose.sell,
                  onSelect: () => setState(() => _selectedRole = AccountPurpose.sell),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Full Name / Workshop Name',
                  hint: 'Sunil Gamage Pottery Works',
                  controller: _nameController,
                  validator: (v) => InputValidators.validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Email Address',
                  hint: 'artisan@hasthakala.lk',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: InputValidators.validateEmail,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: true,
                  controller: _passwordController,
                  validator: InputValidators.validatePassword,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Register Account',
                  isLoading: auth.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await auth.register(
                        email: _emailController.text,
                        password: _passwordController.text,
                        displayName: _nameController.text,
                        primaryPurpose: _selectedRole,
                      );
                      // Return to the root; the AuthGate then shows artisan
                      // setup (Sell) or the buyer home (Shop).
                      if (success && context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
