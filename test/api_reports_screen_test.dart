import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybersecurity_incident_dashboard/screens/api_reports_screen.dart';
import 'package:cybersecurity_incident_dashboard/services/api_service.dart';

void main() {
  group('API Reports Screen', () {
    testWidgets('displays loading indicator while fetching data', (
      tester,
    ) async {
      final completer = Completer<List<ApiReport>>();

      await tester.pumpWidget(
        MaterialApp(
          home: ApiReportsScreen(fetchReports: () => completer.future),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Fetching demo data from REST API...'), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('displays an error message when API request fails', (
      tester,
    ) async {
      final completer = Completer<List<ApiReport>>();

      await tester.pumpWidget(
        MaterialApp(
          home: ApiReportsScreen(fetchReports: () => completer.future),
        ),
      );

      completer.completeError(Exception('Network error'));
      await tester.pumpAndSettle();

      expect(
        find.text('Unable to load API data. Check your internet connection.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('Retry button starts another API request', (tester) async {
      final firstRequest = Completer<List<ApiReport>>();
      final secondRequest = Completer<List<ApiReport>>();
      var requestCount = 0;

      Future<List<ApiReport>> fetchReports() {
        requestCount++;
        return requestCount == 1 ? firstRequest.future : secondRequest.future;
      }

      await tester.pumpWidget(
        MaterialApp(home: ApiReportsScreen(fetchReports: fetchReports)),
      );

      expect(requestCount, 1);

      firstRequest.completeError(Exception('Network error'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(requestCount, 2);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      secondRequest.complete([
        const ApiReport(
          id: 1,
          title: 'Test security report',
          description: 'Test description',
        ),
      ]);

      await tester.pumpAndSettle();

      expect(find.textContaining('1 API records received.'), findsOneWidget);
      expect(find.text('Simulated Security Reports'), findsOneWidget);
      expect(find.text('Suspicious Login Activity'), findsOneWidget);
    });

    testWidgets('displays empty state when API returns no reports', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ApiReportsScreen(fetchReports: () async => [])),
      );

      await tester.pumpAndSettle();

      expect(find.text('No reports available.'), findsOneWidget);
    });
  });
}
