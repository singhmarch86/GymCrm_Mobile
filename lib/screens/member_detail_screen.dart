import 'package:flutter/material.dart';

import '../models/member.dart';
import '../services/member_service.dart';
import 'edit_member_screen.dart';

class MemberDetailScreen extends StatelessWidget {
  final Member member;

  const MemberDetailScreen({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              '${member.firstName} ${member.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone: ${member.phone}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Status: ${member.status}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Email: ${member.email ?? "-"}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Gender: ${member.gender ?? "-"}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Address: ${member.address ?? "-"}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Start Date: ${member.startDate ?? "-"}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Expiry Date: ${member.expiryDate ?? "-"}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit Member',
                ),
                onPressed: () async {
                  final result =
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditMemberScreen(
                            member: member,
                          ),
                    ),
                  );

                  if (result == true &&
                      context.mounted) {
                    Navigator.pop(
                      context,
                      true,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text(
                  'Delete Member',
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                  foregroundColor:
                  Colors.white,
                ),
                onPressed: () async {
                  final confirm =
                  await showDialog<bool>(
                    context: context,
                    builder: (_) =>
                        AlertDialog(
                          title: const Text(
                            'Delete Member',
                          ),
                          content: const Text(
                            'Are you sure you want to delete this member?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  false,
                                );
                              },
                              child: const Text(
                                'Cancel',
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  true,
                                );
                              },
                              child: const Text(
                                'Delete',
                              ),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    try {
                      await MemberService()
                          .deleteMember(
                        member.id,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Member deleted successfully',
                            ),
                          ),
                        );

                        Navigator.pop(
                          context,
                          true,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          SnackBar(
                            content:
                            Text('$e'),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}