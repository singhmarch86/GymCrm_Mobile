import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../services/plan_service.dart';

class EditPlanScreen extends StatefulWidget {
  final Plan plan;

  const EditPlanScreen({
    super.key,
    required this.plan,
  });

  @override
  State<EditPlanScreen> createState() =>
      _EditPlanScreenState();
}

class _EditPlanScreenState
    extends State<EditPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController durationController;
  late TextEditingController priceController;

  bool isActive = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.plan.name,
    );

    descriptionController = TextEditingController(
      text: widget.plan.description ?? '',
    );

    durationController = TextEditingController(
      text: widget.plan.durationDays.toString(),
    );

    priceController = TextEditingController(
      text: widget.plan.priceInRupees.toString(),
    );

    isActive = widget.plan.isActive;
  }

  Future<void> updatePlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await PlanService().updatePlan(
        planId: widget.plan.id,
        name: nameController.text.trim(),
        description:
        descriptionController.text.trim(),
        durationDays: int.parse(
          durationController.text.trim(),
        ),
        priceInRupees: double.parse(
          priceController.text.trim(),
        ),
        isActive: isActive,
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
    descriptionController.dispose();
    durationController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Membership Plan',
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration:
                const InputDecoration(
                  labelText: 'Plan Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                descriptionController,
                maxLines: 3,
                decoration:
                const InputDecoration(
                  labelText:
                  'Description',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                durationController,
                keyboardType:
                TextInputType.number,
                decoration:
                const InputDecoration(
                  labelText:
                  'Duration (Days)',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Required';
                  }

                  if (int.tryParse(value) ==
                      null) {
                    return 'Invalid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                priceController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                const InputDecoration(
                  labelText:
                  'Price (₹)',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Required';
                  }

                  if (double.tryParse(value) ==
                      null) {
                    return 'Invalid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              SwitchListTile(
                value: isActive,
                title: const Text(
                  'Active',
                ),
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : updatePlan,
                  child: isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(),
                  )
                      : const Text(
                    'Update Plan',
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