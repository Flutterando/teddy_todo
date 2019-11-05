import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';
import 'package:teddy_todo/app/app_module.dart';
import 'package:teddy_todo/app/pages/login/login_module.dart';

import 'package:teddy_todo/app/pages/login/login_page.dart';

main() {
  initModule(AppModule());
  initModule(LoginModule());

  testWidgets('LoginPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginPage()));
    final passFinder = find.text('Senha');
    final emailFinder = find.text('Email');
    expect(passFinder, findsOneWidget);
    expect(emailFinder, findsOneWidget);
  });
}
