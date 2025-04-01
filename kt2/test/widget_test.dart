import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt2/main.dart';
void main() {
  testWidgets('Проверка загрузки приложения', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}