import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_incident_dashboard/main.dart';
import 'package:cybersecurity_incident_dashboard/providers/incident_provider.dart';

void main() {
  testWidgets('Cybersecurity dashboard displays its main sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => IncidentProvider(),
        child: const CybersecurityDashboard(),
      ),
    );

    expect(find.text('Cybersecurity Dashboard'), findsOneWidget);
    expect(find.text('Incident Overview'), findsOneWidget);
    expect(find.text('Recent Incidents'), findsOneWidget);
    expect(find.text('Total Incidents'), findsOneWidget);
  });
}
