import 'package:flutter/material.dart';

import '../../login_screen.dart';
import '../../services/auth_service.dart';
import '../../services/dashboard_service.dart';
import '../../services/storage_service.dart';

import 'dashboard_body.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  bool loading = true;

  String token = '';
  String userName = '';
  String role = '';

  int totalMembers = 0;
  int activeMembers = 0;
  int expiredMembers = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final savedToken =
      await StorageService.getAccessToken();

      final savedUser =
      await StorageService.getUserName();

      final savedRole =
      await StorageService.getRole();

      final dashboard =
      await DashboardService().getDashboard();

      if (!mounted) return;

      setState(() {
        token = savedToken ?? '';
        userName = savedUser ?? '';
        role = savedRole ?? '';

        totalMembers =
            dashboard.totalMembers;

        activeMembers =
            dashboard.activeMembers;

        expiredMembers =
            dashboard.expiredMembers;

        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> logout() async {
    try {
      final accessToken =
      await StorageService.getAccessToken();

      if (accessToken != null &&
          accessToken.isNotEmpty) {
        await AuthService().logout(accessToken);
      }
    } catch (_) {}

    await StorageService.clearAll();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      const Color(0xffF7F8FC),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadDashboard,
          child: DashboardBody(
            userName: userName,
            role: role,
            totalMembers: totalMembers,
            activeMembers: activeMembers,
            expiredMembers: expiredMembers,
            onLogout: logout,
          ),
        ),
      ),
    );
  }
}