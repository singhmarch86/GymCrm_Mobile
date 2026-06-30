import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/member.dart';
import 'storage_service.dart';

class MemberService {
  static const String baseUrl = 'http://localhost:8080';

  Future<List<Member>> getMembers() async {
    final token = await StorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/members'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
    );

    debugPrint('Members Status: ${response.statusCode}');
    debugPrint('Members Body: ${response.body}');

    final json = jsonDecode(response.body);

    if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load members');
    }

    final List membersJson =
    json['data']['members'] as List;

    return membersJson
        .map((e) => Member.fromJson(e))
        .toList();
  }

  Future<void> updateMember({
    required int memberId,
    required String firstName,
    required String lastName,
    required String phone,
    required String status,
    int? membershipPlanId,
  }) async {
    final token =
    await StorageService.getAccessToken();

    final response = await http.put(
      Uri.parse(
        '$baseUrl/api/v1/members/$memberId',
      ),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'status': status,
        'membership_plan_id': membershipPlanId,
      }),
    );

    debugPrint(
      'UPDATE STATUS: ${response.statusCode}',
    );

    debugPrint(
      'UPDATE BODY: ${response.body}',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update member',
      );
    }
  }

  Future<void> deleteMember(
      int memberId,
      ) async {
    final token =
    await StorageService.getAccessToken();

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/api/v1/members/$memberId',
      ),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
    );

    debugPrint(
      'DELETE STATUS: ${response.statusCode}',
    );

    debugPrint(
      'DELETE BODY: ${response.body}',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete member',
      );
    }
  }
}