import 'package:flutter/material.dart';

import '../services/plan_service.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> savePlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await PlanService().createPlan(
        name: nameController.text.trim(),
        priceInRupees:
        double.parse(priceController.text.trim()),
        durationDays:
        int.parse(durationController.text.trim()),
        description:
        descriptionController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Membership Plan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Plan Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Plan name is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: priceController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Price (₹)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Price is required";
                  }

                  if (double.tryParse(value) == null) {
                    return "Invalid price";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duration (Days)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Duration is required";
                  }

                  if (int.tryParse(value) == null) {
                    return "Invalid duration";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                  isLoading ? null : savePlan,
                  child: isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "SAVE PLAN",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}