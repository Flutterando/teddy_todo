import 'package:teddy_todo/app/app_module.dart';
import 'package:teddy_todo/app/pages/login/login_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:teddy_todo/app/pages/login/login_page.dart';
import 'package:teddy_todo/app/pages/login/utils/teddy_controller.dart';

class LoginModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LoginBloc(AppModule.to.bloc())),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => TeddyController()),
      ];

  @override
  Widget get view => LoginPage();

  static Inject get to => Inject<LoginModule>.of();
}
