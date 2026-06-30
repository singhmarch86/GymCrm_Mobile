import 'package:flutter/material.dart';

import '../../models/member.dart';
import '../../services/member_service.dart';

import '../../screens/add_member_screen.dart';

import 'member_body.dart';

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

      if (!mounted) return;

      setState(() {
        members = data;
        isLoading = false;
      });

    } catch (e) {

      debugPrint(
        "LOAD MEMBERS ERROR : $e",
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addMember() async {

    final result =
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AddMemberScreen(),
      ),
    );

    if (result == true) {
      await loadMembers();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Members",
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: addMember,
        icon: const Icon(Icons.add),
        label: const Text("Add Member"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MemberBody(
          members: members,
          isLoading: isLoading,
          onRefresh: loadMembers,
        ),
      ),
    );
  }
}