import 'package:teddy_todo/app/shared/services/navigate_service.dart';
import 'package:teddy_todo/app/shared/services/credentials_service.dart';
import 'package:teddy_todo/app/shared/services/local_storage_service.dart';
import 'package:teddy_todo/app/shared/repositories/auth_repository.dart';
import 'package:teddy_todo/app/shared/blocs/auth_bloc.dart';
import 'package:teddy_todo/app/app_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:teddy_todo/app/app_widget.dart';
import 'package:teddy_todo/app/shared/services/custom_dio.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => AuthBloc(i.get(), i.get(), i.get())),
        Bloc((i) => AppBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => NavigateService()),
        Dependency((i) => CredentialsService()),
        Dependency((i) => LocalStorageService()),
        Dependency((i) => AuthRepository(i.get())),
        Dependency((i) => CustomDio(i.get())),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
