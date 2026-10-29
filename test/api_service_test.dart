import 'package:flutter_test/flutter_test.dart';
import 'package:cybersecurity_incident_dashboard/services/api_service.dart';

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
}
