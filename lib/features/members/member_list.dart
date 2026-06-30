import 'package:flutter/material.dart';

import '../../models/member.dart';
import '../../screens/member_detail_screen.dart';

import 'empty_member_state.dart';
import 'member_card.dart';

class MemberList extends StatelessWidget {
  final bool isLoading;
  final List<Member> members;
  final Future<void> Function() onRefresh;

  const MemberList({
    super.key,
    required this.isLoading,
    required this.members,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (members.isEmpty) {
      return const EmptyMemberState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 100,
        ),
        physics:
        const AlwaysScrollableScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final member = members[index];

          return MemberCard(
            member: member,
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
                await onRefresh();
              }
            },
          );
        },
      ),
    );
  }
}