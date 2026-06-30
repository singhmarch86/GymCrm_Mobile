import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/renewal_due.dart';
import 'storage_service.dart';

class RenewalService {
  static const String baseUrl = 'http://localhost:8080';

  /// =========================
  /// GET MEMBERS DUE FOR RENEWAL
  /// =========================
  Future<List<RenewalDue>> getRenewalsDue({
    String filter = 'all',
    String search = '',
  }) async {
    final token = await StorageService.getAccessToken();

    final query = <String, String>{
      if (filter.isNotEmpty && filter != 'all') 'filter': filter,
      if (search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse('$baseUrl/api/v1/members/renewals')
        .replace(queryParameters: query.isEmpty ? null : query);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    debugPrint('RENEWALS DUE STATUS: ${response.statusCode}');
    debugPrint('RENEWALS DUE BODY: ${response.body}');

    if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load renewals');
    }

    final json = jsonDecode(response.body);

    final List renewalsJson = json['data']['renewals'] as List;

    return renewalsJson
        .map((e) => RenewalDue.fromJson(e))
        .toList();
  }

  /// =========================
  /// RENEW A MEMBER
  /// =========================
  Future<void> renewMember({
    required int memberId,
    required int planId,
    required double amountPaidInRupees,
    String? startDate,
    String notes = '',
  }) async {
    final token = await StorageService.getAccessToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/members/$memberId/renew'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plan_id': planId,

        // Backend expects paise
        'amount_paid_in_paise': (amountPaidInRupees * 100).round(),

        if (startDate != null) 'start_date': startDate,
        'notes': notes,
      }),
    );

    debugPrint('RENEW STATUS: ${response.statusCode}');
    debugPrint('RENEW BODY: ${response.body}');

    if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      String message = 'Failed to renew membership';
      try {
        final json = jsonDecode(response.body);
        message = json['error']?['message'] ?? message;
      } catch (_) {}
      throw Exception(message);
    }
  }
}
