import 'package:flutter/material.dart';

import 'models/incident.dart';
import 'screens/incident_details_screen.dart';
import 'widgets/severity_badge.dart';

void main() {
  runApp(const CybersecurityDashboard());
}

const List<Incident> sampleIncidents = [
  Incident(
    id: 'INC-001',
    title: 'Phishing Attack',
    description:
        'A suspicious email was detected attempting to steal user credentials.',
    severity: 'High',
    status: 'Open',
    category: 'Phishing',
  ),
  Incident(
    id: 'INC-002',
    title: 'Malware Detection',
    description: 'Malicious software was detected on an employee workstation.',
    severity: 'Critical',
    status: 'Investigating',
    category: 'Malware',
  ),
  Incident(
    id: 'INC-003',
    title: 'Brute Force Attack',
    description:
        'Multiple failed login attempts were detected on a user account.',
    severity: 'Medium',
    status: 'Resolved',
    category: 'Unauthorized Access',
  ),
  Incident(
    id: 'INC-004',
    title: 'Data Leak',
    description:
        'A potential exposure of confidential information requires investigation.',
    severity: 'High',
    status: 'Open',
    category: 'Data Security',
  ),
];

class CybersecurityDashboard extends StatelessWidget {
  const CybersecurityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cybersecurity Incident Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {"/": (context) => const DashboardScreen()},
      onGenerateRoute: (settings) {
        if (settings.name == "/incident-details") {
          final incident = settings.arguments as Incident;
          return MaterialPageRoute(
            builder: (context) => IncidentDetailsScreen(incident: incident),
          );
        }
        return null;
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedSeverity = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredIncidents = selectedSeverity == 'All'
        ? sampleIncidents
        : sampleIncidents
              .where(
                (incident) =>
                    incident.severity.toLowerCase() ==
                    selectedSeverity.toLowerCase(),
              )
              .toList();

    final criticalCount = sampleIncidents
        .where((incident) => incident.severity == 'Critical')
        .length;
    final highCount = sampleIncidents
        .where((incident) => incident.severity == 'High')
        .length;
    final resolvedCount = sampleIncidents
        .where((incident) => incident.status == 'Resolved')
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cybersecurity Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Incident Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 600 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _statCard(
                      "Total Incidents",
                      sampleIncidents.length.toString(),
                    ),
                    _statCard("Critical", criticalCount.toString()),
                    _statCard("High", highCount.toString()),
                    _statCard("Resolved", resolvedCount.toString()),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Incidents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Filter by severity',
                border: OutlineInputBorder(),
              ),
              items: const ['All', 'Critical', 'High', 'Medium', 'Low']
                  .map(
                    (severity) => DropdownMenuItem(
                      value: severity,
                      child: Text(severity),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSeverity = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredIncidents.isEmpty
                  ? const Center(child: Text('No incidents found.'))
                  : ListView.builder(
                      itemCount: filteredIncidents.length,
                      itemBuilder: (context, index) {
                        final incident = filteredIncidents[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(
                              Icons.security,
                              color: Colors.blue,
                              size: 30,
                            ),
                            title: Text(incident.title),
                            subtitle: Text(
                              '${incident.id} • Status: ${incident.status}',
                            ),
                            trailing: SeverityBadge(
                              severity: incident.severity,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/incident-details",
                                arguments: incident,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
