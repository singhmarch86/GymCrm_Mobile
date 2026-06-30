import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_response.dart';
import 'storage_service.dart';

class DashboardService {
  static const String baseUrl = 'http://localhost:8080';

  Future getDashboard() async {
    final token = await StorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
      },
    );

    debugPrint('Dashboard Status: ${response.statusCode}');
    debugPrint('Dashboard Body: ${response.body}');

    final json = jsonDecode(response.body);

    return DashboardResponse.fromJson(
      json['data'],
    );

  }
}