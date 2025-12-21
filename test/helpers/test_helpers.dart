import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Future<void> pumpApp(
  WidgetTester tester,
  Widget widget, {
  NavigatorObserver? navigatorObserver,
  List<BlocProvider>? providers,
  Map<String, WidgetBuilder>? routes,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: providers != null
          ? MultiBlocProvider(providers: providers, child: widget)
          : widget,
      routes: routes ?? {},
      navigatorObservers: [if (navigatorObserver != null) navigatorObserver],
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    ),
  );
}
