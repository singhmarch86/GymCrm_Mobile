import 'package:flutter/material.dart';

import '../models/member.dart';
import '../models/plan.dart';
import '../services/member_service.dart';
import '../services/plan_service.dart';

class EditMemberScreen extends StatefulWidget {
  final Member member;

  const EditMemberScreen({
    super.key,
    required this.member,
  });

  @override
  State<EditMemberScreen> createState() =>
          _EditMemberScreenState();
}

class _EditMemberScreenState
    extends State<EditMemberScreen>  {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;

  bool isLoading = false;

  String status = 'active';

  List plans = [];

  int? selectedPlanId;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(
      text: widget.member.firstName,
    );

    lastNameController = TextEditingController(
      text: widget.member.lastName,
    );

    phoneController = TextEditingController(
      text: widget.member.phone,
    );

    status = widget.member.status;

    selectedPlanId =
        widget.member.membershipPlanId;

    loadPlans();

  }

  Future loadPlans() async {
    try {
      final data =
      await PlanService().getActivePlans();

      if (!mounted) return;

      setState(() {
        plans = data;
      });
    } catch (e) {
      debugPrint('PLAN ERROR: $e');
    }

  }

  Future updateMember() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await MemberService().updateMember(
        memberId: widget.member.id,
        firstName:
        firstNameController.text.trim(),
        lastName:
        lastNameController.text.trim(),
        phone:
        phoneController.text.trim(),
        status: status,
        membershipPlanId:
        selectedPlanId,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Member',
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
                controller:
                firstNameController,
                decoration:
                const InputDecoration(
                  labelText:
                  'First Name',
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
                lastNameController,
                decoration:
                const InputDecoration(
                  labelText:
                  'Last Name',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                phoneController,
                decoration:
                const InputDecoration(
                  labelText: 'Phone',
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

              DropdownButtonFormField<int>(
                initialValue:
                selectedPlanId,
                decoration:
                const InputDecoration(
                  labelText:
                  'Membership Plan',
                ),
                items: plans
                    .map(
                      (plan) =>
                      DropdownMenuItem<
                          int>(
                        value: plan.id,
                        child: Text(
                          '${plan.name} (₹${plan.priceInRupees})',
                        ),
                      ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPlanId =
                        value;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<
                  String>(
                initialValue: status,
                decoration:
                const InputDecoration(
                  labelText: 'Status',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'active',
                    child: Text(
                      'Active',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'expired',
                    child: Text(
                      'Expired',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'inactive',
                    child: Text(
                      'Inactive',
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      status = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : updateMember,
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(),
                  )
                      : const Text(
                    'Update Member',
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