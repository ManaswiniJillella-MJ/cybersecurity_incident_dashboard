import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ApiReportsScreen extends StatefulWidget {
  const ApiReportsScreen({super.key});

  @override
  State<ApiReportsScreen> createState() => _ApiReportsScreenState();
}

class _ApiReportsScreenState extends State<ApiReportsScreen> {
  late Future<List<ApiReport>> _reportsFuture;

  final List<Map<String, String>> _securityExamples = [
    {
      'title': 'Suspicious Login Activity',
      'category': 'Authentication',
      'severity': 'High',
    },
    {
      'title': 'Phishing Email Detection',
      'category': 'Email Security',
      'severity': 'Medium',
    },
    {
      'title': 'Malware Detection Alert',
      'category': 'Endpoint Security',
      'severity': 'Critical',
    },
    {
      'title': 'Unusual Network Traffic',
      'category': 'Network Security',
      'severity': 'High',
    },
    {
      'title': 'Possible Data Exposure',
      'category': 'Data Security',
      'severity': 'Medium',
    },
  ];

  @override
  void initState() {
    super.initState();
    _reportsFuture = ApiService.fetchReports();
  }

  void _retry() {
    setState(() {
      _reportsFuture = ApiService.fetchReports();
    });
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.deepOrange;
      default:
        return Colors.amber.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security API Reports')),
      body: FutureBuilder<List<ApiReport>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching demo data from REST API...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load API data. Check your internet connection.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return const Center(child: Text('No reports available.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${reports.length} API records received. '
                          'The security scenarios below are simulated examples, '
                          'not live cybersecurity alerts.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Simulated Security Reports',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ...reports.asMap().entries.map((entry) {
                final index = entry.key;
                final apiReport = entry.value;
                final example =
                    _securityExamples[index % _securityExamples.length];
                final severity = example['severity']!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.security,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      example['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${example['category']}'),
                          const SizedBox(height: 4),
                          Text('Demo record ID: ${apiReport.id}'),
                          const SizedBox(height: 8),
                          Text(
                            'Sample API text: ${apiReport.title}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Severity: $severity',
                            style: TextStyle(
                              color: _severityColor(severity),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
