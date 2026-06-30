import 'package:flutter/material.dart';

import '../../models/renewal_due.dart';
import '../../services/renewal_service.dart';

import 'renew_dialog.dart';
import 'renewal_filter_bar.dart';
import 'renewals_body.dart';

class RenewalsScreen extends StatefulWidget {
  const RenewalsScreen({super.key});

  @override
  State<RenewalsScreen> createState() => _RenewalsScreenState();
}

class _RenewalsScreenState extends State<RenewalsScreen> {
  bool isLoading = true;

  List<RenewalDue> renewals = [];

  RenewalFilterOption currentFilter = RenewalFilterOption.all;
  String currentSearch = '';

  @override
  void initState() {
    super.initState();
    loadRenewals();
  }

  Future<void> loadRenewals() async {
    try {
      final data = await RenewalService().getRenewalsDue(
        filter: currentFilter.apiValue,
        search: currentSearch,
      );

      if (!mounted) return;

      setState(() {
        renewals = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("LOAD RENEWALS ERROR : $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  void onQueryChanged({
    required RenewalFilterOption filter,
    required String search,
  }) {
    currentFilter = filter;
    currentSearch = search;

    setState(() {
      isLoading = true;
    });

    loadRenewals();
  }

  Future<void> onRenew(RenewalDue renewal) async {
    final result = await showRenewDialog(context, renewal: renewal);

    if (result == true) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${renewal.memberName}'s membership renewed",
          ),
        ),
      );

      await loadRenewals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Renewals"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RenewalsBody(
          renewals: renewals,
          isLoading: isLoading,
          onQueryChanged: onQueryChanged,
          onRefresh: loadRenewals,
          onRenew: onRenew,
        ),
      ),
    );
  }
}
