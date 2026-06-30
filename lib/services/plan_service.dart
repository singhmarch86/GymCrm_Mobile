import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/plan.dart';
import 'storage_service.dart';

class PlanService {
  static const String baseUrl = 'http://localhost:8080';

  /// =========================
  /// GET ALL PLANS
  /// =========================
  Future<List<Plan>> getActivePlans() async {
    final token = await StorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/plans'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
    );

    debugPrint('PLANS STATUS: ${response.statusCode}');
    debugPrint('PLANS BODY: ${response.body}');

    if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load plans');
    }

    final json = jsonDecode(response.body);

    final List plansJson = json['data']['plans'];

    return plansJson
        .map((e) => Plan.fromJson(e))
        .toList();
  }

  /// =========================
  /// CREATE PLAN
  /// =========================
  Future<void> createPlan({
    required String name,
    required double priceInRupees,
    required int durationDays,
    String description = '',
  }) async {
    final token = await StorageService.getAccessToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/plans'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'duration_days': durationDays,

        // Backend expects paise
        'price_in_paise':
        (priceInRupees * 100).round(),
      }),
    );

    debugPrint(
        'CREATE PLAN STATUS: ${response.statusCode}');
    debugPrint(
        'CREATE PLAN BODY: ${response.body}');

    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      throw Exception('Failed to create plan');
    }
  }

  /// =========================
  /// UPDATE PLAN
  /// =========================
  Future<void> updatePlan({
    required int planId,
    required String name,
    required double priceInRupees,
    required int durationDays,
    required bool isActive,
    String description = '',
  }) async {
    final token = await StorageService.getAccessToken();

    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/plans/$planId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'duration_days': durationDays,

        // Backend expects paise
        'price_in_paise':
        (priceInRupees * 100).round(),

        'is_active': isActive,
      }),
    );

    debugPrint(
        'UPDATE PLAN STATUS: ${response.statusCode}');
    debugPrint(
        'UPDATE PLAN BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update plan');
    }
  }

  /// =========================
  /// DELETE PLAN
  /// =========================
  Future<void> deletePlan(int planId) async {
    final token = await StorageService.getAccessToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/plans/$planId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
    );

    debugPrint(
        'DELETE PLAN STATUS: ${response.statusCode}');
    debugPrint(
        'DELETE PLAN BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete plan');
    }
  }
}