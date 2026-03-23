// This is a basic Flutter widget test.
// To perform an interaction with a widget in the test, use the WidgetTester
// utility in the flutter_test package.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:wine_ai/main.dart';
import 'package:wine_ai/providers/user_provider.dart';
import 'package:wine_ai/providers/wine_provider.dart';
import 'package:wine_ai/providers/vault_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app with providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => WineProvider(apiKey: '')),
          ChangeNotifierProvider(create: (_) => VaultProvider()),
        ],
        child: const MaterialApp(
          home: MainNavigationScreen(),
        ),
      ),
    );

    // Verify that the app loads with navigation
    expect(find.byType(MainNavigationScreen), findsOneWidget);
  });
}
