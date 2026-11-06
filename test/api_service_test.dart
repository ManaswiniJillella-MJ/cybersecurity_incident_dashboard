import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:cybersecurity_incident_dashboard/services/api_service.dart';

class FakeClient extends http.BaseClient {
  FakeClient(this.statusCode, this.body);

  final int statusCode;
  final String body;

  Uri? requestedUrl;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUrl = request.url;

    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      statusCode,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
}

void main() {
  group('ApiReport JSON parsing', () {
    test('parses a valid API response', () {
      final report = ApiReport.fromJson({
        'id': 7,
        'title': 'Suspicious login',
        'body': 'Repeated login attempts detected.',
      });

      expect(report.id, 7);
      expect(report.title, 'Suspicious login');
      expect(report.description, 'Repeated login attempts detected.');
    });

    test('rejects a response with a missing required field', () {
      expect(
        () => ApiReport.fromJson({'id': 7, 'title': 'Suspicious login'}),
        throwsA(anything),
      );
    });
  });

  group('ApiService HTTP handling', () {
    test('successfully fetches and parses reports', () async {
      final client = FakeClient(
        200,
        jsonEncode([
          {
            'id': 1,
            'title': 'Security report',
            'body': 'Suspicious activity detected.',
          },
        ]),
      );

      final reports = await ApiService.fetchReports(client: client);

      expect(reports.length, 1);
      expect(reports.first.id, 1);
      expect(reports.first.title, 'Security report');
      expect(reports.first.description, 'Suspicious activity detected.');
      expect(client.requestedUrl?.path, '/posts');
      expect(client.requestedUrl?.queryParameters['_limit'], '5');
    });

    test('throws an exception for HTTP 404', () async {
      final client = FakeClient(404, 'Not found');

      expect(
        () => ApiService.fetchReports(client: client),
        throwsA(predicate((error) => error.toString().contains('404'))),
      );
    });

    test('throws an exception for HTTP 500', () async {
      final client = FakeClient(500, 'Server error');

      expect(
        () => ApiService.fetchReports(client: client),
        throwsA(predicate((error) => error.toString().contains('500'))),
      );
    });

    test('throws FormatException for invalid JSON', () async {
      final client = FakeClient(200, 'invalid JSON');

      expect(
        () => ApiService.fetchReports(client: client),
        throwsFormatException,
      );
    });
  });
}
