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

    test('resets the severity filter to show all incidents', () {
      provider.setSeverity('High');
      expect(provider.filteredIncidents.length, 2);

      provider.setSeverity('All');

      expect(provider.selectedSeverity, 'All');
      expect(provider.filteredIncidents.length, 4);
    });

    test('notifies listeners when the severity filter changes', () {
      var notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.setSeverity('Critical');

      expect(notified, isTrue);
      expect(provider.selectedSeverity, 'Critical');
      expect(provider.filteredIncidents.length, 1);
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
    test('starts with an empty search query', () {
      expect(provider.searchQuery, '');
      expect(provider.filteredIncidents.length, 4);
    });

    test('searches incidents by ID', () {
      provider.setSearchQuery('INC-004');

      expect(provider.filteredIncidents.length, 1);
      expect(provider.filteredIncidents.first.title, 'Data Leak');
    });

    test('searches incidents by title case-insensitively', () {
      provider.setSearchQuery('mALwArE');

      expect(provider.filteredIncidents.length, 1);
      expect(provider.filteredIncidents.first.title, 'Malware Detection');
    });

    test('searches incidents by description', () {
      provider.setSearchQuery('credentials');

      expect(provider.filteredIncidents.length, 1);
      expect(provider.filteredIncidents.first.id, 'INC-001');
    });

    test('searches incidents by category', () {
      provider.setSearchQuery('Unauthorized Access');

      expect(provider.filteredIncidents.length, 1);
      expect(provider.filteredIncidents.first.id, 'INC-003');
    });

    test('combines search with severity filtering', () {
      provider.setSeverity('High');
      provider.setSearchQuery('attack');

      expect(provider.filteredIncidents.length, 1);
      expect(provider.filteredIncidents.first.id, 'INC-001');
      expect(
        provider.filteredIncidents.every(
          (incident) => incident.severity == 'High',
        ),
        isTrue,
      );
    });

    test('clears search and restores filtered incidents', () {
      provider.setSearchQuery('malware');

      expect(provider.filteredIncidents.length, 1);

      provider.clearSearch();

      expect(provider.searchQuery, '');
      expect(provider.filteredIncidents.length, 4);
    });

    test('notifies listeners when search query changes', () {
      var notified = false;

      provider.addListener(() {
        notified = true;
      });

      provider.setSearchQuery('phishing');

      expect(notified, isTrue);
      expect(provider.searchQuery, 'phishing');
    });
  });
}
