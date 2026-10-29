import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiReport {
  final int id;
  final String title;
  final String description;

  const ApiReport({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ApiReport.fromJson(Map<String, dynamic> json) {
    return ApiReport(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['body'] as String,
    );
  }
}

class ApiService {
  static Future<List<ApiReport>> fetchReports() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('API request failed: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => ApiReport.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
