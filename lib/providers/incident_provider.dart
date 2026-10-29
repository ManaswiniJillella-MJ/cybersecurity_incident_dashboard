import 'package:flutter/foundation.dart';

import '../models/incident.dart';

class IncidentProvider extends ChangeNotifier {
  final List<Incident> _incidents = [
    Incident(
      id: 'INC-001',
      title: 'Phishing Attack',
      description: 'A suspicious email attempted to steal user credentials.',
      severity: 'High',
      status: 'Open',
      category: 'Phishing',
    ),
    Incident(
      id: 'INC-002',
      title: 'Malware Detection',
      description: 'Malicious software was detected on a workstation.',
      severity: 'Critical',
      status: 'Investigating',
      category: 'Malware',
    ),
    Incident(
      id: 'INC-003',
      title: 'Brute Force Attack',
      description: 'Repeated failed login attempts were detected.',
      severity: 'Medium',
      status: 'Resolved',
      category: 'Unauthorized Access',
    ),
    Incident(
      id: 'INC-004',
      title: 'Data Leak',
      description: 'Potential unauthorized exposure of sensitive data.',
      severity: 'High',
      status: 'Open',
      category: 'Data Security',
    ),
  ];

  String _selectedSeverity = 'All';

  List<Incident> get incidents => List.unmodifiable(_incidents);

  String get selectedSeverity => _selectedSeverity;

  List<Incident> get filteredIncidents {
    if (_selectedSeverity == 'All') {
      return incidents;
    }

    return _incidents
        .where((incident) => incident.severity == _selectedSeverity)
        .toList();
  }

  int get totalCount => _incidents.length;

  int get criticalCount =>
      _incidents.where((incident) => incident.severity == 'Critical').length;

  int get highCount =>
      _incidents.where((incident) => incident.severity == 'High').length;

  void addIncident({
    required String title,
    required String description,
    required String severity,
    required String category,
  }) {
    final nextNumber = _incidents.length + 1;
    final id = 'INC-${nextNumber.toString().padLeft(3, '0')}';

    _incidents.insert(
      0,
      Incident(
        id: id,
        title: title.trim(),
        description: description.trim(),
        severity: severity,
        status: 'Open',
        category: category,
      ),
    );

    notifyListeners();
  }

  void setSeverity(String severity) {
    if (_selectedSeverity == severity) return;

    _selectedSeverity = severity;
    notifyListeners();
  }
}
