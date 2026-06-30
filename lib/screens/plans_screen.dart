import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../services/plan_service.dart';
import 'add_plan_screen.dart';
import 'edit_plan_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool isLoading = true;

  List<Plan> plans = [];

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    try {
      final data = await PlanService().getActivePlans();

      if (!mounted) return;

      setState(() {
        plans = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('PLANS ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddPlanScreen(),
                ),
              );

              if (result == true) {
                loadPlans();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : plans.isEmpty
          ? const Center(
        child: Text(
          'No Membership Plans Found',
          style: TextStyle(fontSize: 16),
        ),
      )
          : RefreshIndicator(
        onRefresh: loadPlans,
        child: ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              elevation: 2,
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.workspace_premium),
                ),
                title: Text(
                  plan.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price : ₹${plan.priceInRupees.toStringAsFixed(0)}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration : ${plan.durationDays} Days',
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () async {
                  final updated =
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditPlanScreen(
                            plan: plan,
                          ),
                    ),
                  );

                  if (updated == true) {
                    loadPlans();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}