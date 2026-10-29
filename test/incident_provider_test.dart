import 'package:flutter_test/flutter_test.dart';
import 'package:cybersecurity_incident_dashboard/models/incident.dart';
import 'package:cybersecurity_incident_dashboard/providers/incident_provider.dart';

void main() {
  group('IncidentProvider tests', () {
    late IncidentProvider provider;

    setUp(() {
      provider = IncidentProvider();
    });

    test('starts with four sample incidents', () {
      expect(provider.incidents.length, 4);
      expect(provider.totalCount, 4);
    });

    test('filters incidents by High severity', () {
      provider.setSeverity('High');

      expect(provider.filteredIncidents.length, 2);
      expect(
        provider.filteredIncidents.every(
          (incident) => incident.severity == 'High',
        ),
        isTrue,
      );
    });

    test('adds a new incident successfully', () {
      provider.addIncident(
        title: 'Suspicious Login',
        description: 'Unusual login activity was detected.',
        severity: 'Critical',
        category: 'Unauthorized Access',
      );

      expect(provider.totalCount, 5);
      expect(provider.incidents.first.title, 'Suspicious Login');
      expect(provider.incidents.first.severity, 'Critical');
      expect(provider.incidents.first.status, 'Open');
    });

    test('notifies listeners when an incident is added', () {
      var notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.addIncident(
        title: 'Test Incident',
        description: 'This is a test incident description.',
        severity: 'Low',
        category: 'Other',
      );

      expect(notified, isTrue);
    });

    test('returns an unmodifiable incident list', () {
      expect(
        () => provider.incidents.add(
          const Incident(
            id: 'INC-999',
            title: 'Test',
            description: 'Test description',
            severity: 'Low',
            status: 'Open',
            category: 'Other',
          ),
        ),
        throwsUnsupportedError,
      );
    });
  });
}
