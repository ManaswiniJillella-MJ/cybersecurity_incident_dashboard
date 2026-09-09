import 'package:flutter/material.dart';

void main() {
  runApp(const CybersecurityDashboard());
}

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
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cybersecurity Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Incident Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _statCard('Total Incidents', '24')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Critical', '4')),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _statCard('High', '8')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Resolved', '15')),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Recent Incidents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: const [
                  IncidentCard(
                    id: 'INC-001',
                    type: 'Phishing Attack',
                    severity: 'HIGH',
                    status: 'Open',
                  ),
                  IncidentCard(
                    id: 'INC-002',
                    type: 'Malware Detection',
                    severity: 'CRITICAL',
                    status: 'Investigating',
                  ),
                  IncidentCard(
                    id: 'INC-003',
                    type: 'Brute Force Attack',
                    severity: 'MEDIUM',
                    status: 'Resolved',
                  ),
                  IncidentCard(
                    id: 'INC-004',
                    type: 'Data Leak',
                    severity: 'HIGH',
                    status: 'Open',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _statCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
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

class IncidentCard extends StatelessWidget {
  final String id;
  final String type;
  final String severity;
  final String status;

  const IncidentCard({
    super.key,
    required this.id,
    required this.type,
    required this.severity,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.security),
        title: Text(type),
        subtitle: Text('$id • Status: $status'),
        trailing: Text(
          severity,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
