// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:majadigi/app.dart';
// import 'package:majadigi/core/di/di.dart' as di;
//
// void main() {
//   setUpAll(() async {
//     // Initialize dependency injection before running tests
//     di.init();
//   });
//
//   tearDownAll(() {
//     // Clean up after tests
//     di.sl.reset();
//   });
//
//   testWidgets('App loads successfully', (WidgetTester tester) async {
//     // Build our app and trigger a frame with proper sizing
//     addTearDown(tester.binding.window.physicalSizeTestValue = const Size(540, 960));
//     addTearDown(
//       () => addTearDown(
//         () => tester.binding.window.clearPhysicalSizeTestValue(),
//       ),
//     );
//
//     await tester.binding.window.physicalSizeTestValue = const Size(540, 960);
//     await tester.pumpWidget(const App());
//
//     // Wait for app to fully build and layout
//     await tester.pumpAndSettle();
//
//     // Verify Material App is present
//     expect(find.byType(MaterialApp), findsWidgets);
//     expect(find.byType(App), findsOneWidget);
//   });
// }
