import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/storage_service.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() =>
      _AddMemberScreenState();
}

class _AddMemberScreenState
    extends State<AddMemberScreen> {

  final firstNameController =
  TextEditingController();

  final lastNameController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final addressController =
  TextEditingController();

  final startDateController =
  TextEditingController();

  final expiryDateController =
  TextEditingController();

  bool isLoading = false;

  Future<void> saveMember() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token =
      await StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse(
          'http://localhost:8080/api/v1/members',
        ),
        headers: {
          'Content-Type': 'application/json',
          if (token != null)
            'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'first_name':
          firstNameController.text,
          'last_name':
          lastNameController.text,
          'phone':
          phoneController.text,
          'email':
          emailController.text,
          'address':
          addressController.text,
          'gender': 'male',
          'start_date':
          startDateController.text,
          'expiry_date':
          expiryDateController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
            Text('Member added successfully'),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content:
            Text(response.body),
          ),
        );
      }
    } catch (e) {
      debugPrint('ADD MEMBER ERROR: $e');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Widget buildTextField(
      String label,
      TextEditingController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border:
          const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Add Member'),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [

            buildTextField(
              'First Name',
              firstNameController,
            ),

            buildTextField(
              'Last Name',
              lastNameController,
            ),

            buildTextField(
              'Phone',
              phoneController,
            ),

            buildTextField(
              'Email',
              emailController,
            ),

            buildTextField(
              'Address',
              addressController,
            ),

            buildTextField(
              'Start Date (YYYY-MM-DD)',
              startDateController,
            ),

            buildTextField(
              'Expiry Date (YYYY-MM-DD)',
              expiryDateController,
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                isLoading
                    ? null
                    : saveMember,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  'Save Member',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}