import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqlite/models/task.dart';
import 'helper/database_helper_test.mocks.dart';

void main() {
  testWidgets('Task List displays tasks', (WidgetTester tester) async {
    // Mock database helper
    final mockDbHelper = MockDatabaseHelper();
    when(
      mockDbHelper.getTasks(),
    ).thenAnswer((_) async => [Task(id: 1, title: 'Mock Task')]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureBuilder<List<Task>>(
            future: mockDbHelper.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(snapshot.data![index].title));
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Mock Task'), findsOneWidget);
  });
}
