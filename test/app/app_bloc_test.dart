import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:teddy_todo/app/app_bloc.dart';
import 'package:teddy_todo/app/app_module.dart';

void main() {
  initModule(AppModule());
  AppBloc bloc;

  setUp(() {
    bloc = AppModule.to.bloc<AppBloc>();
  });

  group('AppBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<AppBloc>());
    });
  });
}
