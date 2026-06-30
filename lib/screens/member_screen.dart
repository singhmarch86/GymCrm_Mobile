import 'package:flutter/material.dart';

import '../models/member.dart';
import '../services/member_service.dart';
import 'add_member_screen.dart';
import 'member_detail_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() =>
      _MembersScreenState();
}

class _MembersScreenState
    extends State<MembersScreen> {

  bool isLoading = true;

  List<Member> members = [];

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  Future<void> loadMembers() async {
    try {
      final data =
      await MemberService().getMembers();

      debugPrint(
        'MEMBERS COUNT = ${data.length}',
      );

      for (final m in data) {
        debugPrint(
          '${m.firstName} ${m.lastName} - ${m.phone}',
        );
      }

      if (!mounted) return;

      setState(() {
        members = data;
        isLoading = false;
      });

    } catch (e) {
      debugPrint('MEMBERS ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;

      case 'expired':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {

              final result =
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const AddMemberScreen(),
                ),
              );

              if (result == true) {
                loadMembers();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: members.length,
        itemBuilder:
            (context, index) {

          final member =
          members[index];

          return Card(
            margin:
            const EdgeInsets.all(
              10,
            ),
            child: ListTile(

              onTap: () async {

                final result =
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MemberDetailScreen(
                          member: member,
                        ),
                  ),
                );

                if (result == true) {
                  loadMembers();
                }
              },

              title: Text(
                '${member.firstName} ${member.lastName}',
              ),

              subtitle: Text(
                member.phone,
              ),

              trailing: Text(
                member.status,
                style: TextStyle(
                  color:
                  getStatusColor(
                    member.status,
                  ),
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}