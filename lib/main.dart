import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/incident_provider.dart';
import 'models/incident.dart';
import 'screens/incident_details_screen.dart';
import 'screens/api_reports_screen.dart';
import 'screens/report_incident_screen.dart';
import 'widgets/severity_badge.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => IncidentProvider(),
      child: const CybersecurityDashboard(),
    ),
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/api-reports': (context) => const ApiReportsScreen(),
        '/report-incident': (context) => const ReportIncidentScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/incident-details') {
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
  @override
  Widget build(BuildContext context) {
    final incidentProvider = context.watch<IncidentProvider>();

    final filteredIncidents = incidentProvider.filteredIncidents;
    final incidents = incidentProvider.incidents;

    final criticalCount = incidents
        .where((incident) => incident.severity == 'Critical')
        .length;

    final highCount = incidents
        .where((incident) => incident.severity == 'High')
        .length;

    final resolvedCount = incidents
        .where((incident) => incident.status == 'Resolved')
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cybersecurity Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            tooltip: 'API Demo Reports',
            icon: const Icon(Icons.cloud_download_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/api-reports');
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/report-incident');
        },
        icon: const Icon(Icons.add),
        label: const Text('Report Incident'),
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
                  childAspectRatio: 1.8,
                  children: [
                    _statCard('Total Incidents', incidents.length.toString()),
                    _statCard('Critical', criticalCount.toString()),
                    _statCard('High', highCount.toString()),
                    _statCard('Resolved', resolvedCount.toString()),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Recent Incidents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              key: const Key('incidentSearchField'),
              onChanged: (value) {
                context.read<IncidentProvider>().setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by ID, title, description or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: incidentProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        key: const Key('clearSearchButton'),
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                        onPressed: () {
                          context.read<IncidentProvider>().clearSearch();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: incidentProvider.selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Filter by Severity',
                border: OutlineInputBorder(),
              ),
              items: const ['All', 'Critical', 'High', 'Medium', 'Low'].map((
                severity,
              ) {
                return DropdownMenuItem<String>(
                  value: severity,
                  child: Text(severity),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<IncidentProvider>().setSeverity(value);
                }
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              child: filteredIncidents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 40,
                            color: Colors.grey,
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'No incidents found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            incidentProvider.searchQuery.isNotEmpty
                                ? 'No incidents match '
                                      '"${incidentProvider.searchQuery}".'
                                : 'No incidents match the '
                                      '${incidentProvider.selectedSeverity} '
                                      'severity filter.',
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 4),

                          if (incidentProvider.selectedSeverity != 'All')
                            OutlinedButton.icon(
                              onPressed: () {
                                context.read<IncidentProvider>().setSeverity(
                                  'All',
                                );
                              },
                              icon: const Icon(Icons.filter_alt_off),
                              label: const Text('Clear filter'),
                            ),
                        ],
                      ),
                    )
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
                                '/incident-details',
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
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                value,
                key: ValueKey(value),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
