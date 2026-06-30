import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final gymNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthService().register(
        gymName: gymNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        address: addressController.text.trim(),
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final data = result['data'];

        await StorageService.saveAuthData(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          userId: data['user']['id'],
          gymId: data['user']['gym_id'],
          userName: data['user']['name'],
          role: data['user']['role'],
        );

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['error']['message'],
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    gymNameController.dispose();
    ownerNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    cityController.dispose();
    stateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget field(
      TextEditingController controller,
      String label, {
        bool obscure = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Gym'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            field(gymNameController, 'Gym Name'),
            field(ownerNameController, 'Owner Name'),
            field(phoneController, 'Phone'),
            field(passwordController, 'Password', obscure: true),
            field(emailController, 'Email'),
            field(cityController, 'City'),
            field(stateController, 'State'),
            field(addressController, 'Address'),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : register,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}