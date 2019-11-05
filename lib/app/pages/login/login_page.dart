import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:teddy_todo/app/app_module.dart';
import 'package:teddy_todo/app/pages/home/home_module.dart';
import 'package:teddy_todo/app/pages/login/login_module.dart';
import 'package:teddy_todo/app/pages/login/utils/teddy_controller.dart';
import 'package:teddy_todo/app/shared/blocs/auth_bloc.dart';
import 'package:teddy_todo/app/shared/services/navigate_service.dart';
import 'components/signin_button.dart';
import 'components/tracking_text_input.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TeddyController _teddyController = LoginModule.to.get();
  LoginBloc loginBloc = LoginModule.to.bloc();
  AuthBloc authBloc = AppModule.to.bloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription loginBlocSubscription;
  StreamSubscription authBlocSubscription;

  @override
  initState() {
    super.initState();
    authBlocSubscription = authBloc.isLogin.listen((isLogin) {
      if (isLogin) {
        _pushToHome();
      }
    });

    loginBlocSubscription = loginBloc.loginStatus.listen((status) async {
      if (status == LoginStatus.ERROR) {
        _teddyController.play("fail");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Erro no login",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else if (status == LoginStatus.LOADING) {
        _teddyController.play("hands_down");
      } else if (status == LoginStatus.GET_USER) {
        _teddyController.play("success");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Perfeito! Pegando usuário!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  _pushToHome() async {
    await Future.delayed(Duration(seconds: 2));
    await AppModule.to
        .get<NavigateService>()
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return HomeModule();
    }));
  }

  @override
  dispose() {
    super.dispose();
    loginBlocSubscription.cancel();
    authBlocSubscription.cancel();
  }

  Widget _background() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            colors: [
              Color.fromRGBO(170, 207, 211, 1.0),
              Color.fromRGBO(93, 142, 155, 1.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teddy() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: FlareActor(
        "assets/Teddy.flr",
        shouldClip: false,
        alignment: Alignment.bottomCenter,
        fit: BoxFit.contain,
        controller: _teddyController,
      ),
    );
  }

  Widget _form() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TrackingTextInput(
                label: "Email",
                hint: "Tente user@flutterando.com",
                onCaretMoved: (Offset caret) {
                  _teddyController.lookAt(caret);
                },
                onTextChanged: (String value) {
                  loginBloc.email = value;
                },
              ),
              TrackingTextInput(
                label: "Senha",
                hint: "Tente '123'...",
                isObscured: true,
                onCaretMoved: (Offset caret) {
                  _teddyController.coverEyes(caret != null);
                  _teddyController.lookAt(null);
                },
                onTextChanged: (String value) {
                  loginBloc.pass = value;
                },
              ),
              StreamBuilder<LoginStatus>(
                  stream: loginBloc.loginStatus,
                  initialData: LoginStatus.IDLE,
                  builder: (context, snapshot) {
                    return SigninButton(
                      child: snapshot.data == LoginStatus.LOADING ||
                              snapshot.data == LoginStatus.GET_USER
                          ? CircularProgressIndicator()
                          : Text(
                              snapshot.data == LoginStatus.SUCCESS
                                  ? "Passou!!"
                                  : "Entrar",
                              style: TextStyle(
                                  fontFamily: "RobotoMedium",
                                  fontSize: 16,
                                  color: Colors.white)),
                      onPressed: snapshot.data == LoginStatus.LOADING ||
                              snapshot.data == LoginStatus.GET_USER ||
                              snapshot.data == LoginStatus.SUCCESS
                          ? null
                          : () async {
                              loginBloc.login();
                            },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return Positioned.fill(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_teddy(), _form()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
      body: Container(
          child: Stack(
        children: <Widget>[
          _background(),
          StreamBuilder<bool>(
              stream: authBloc.isLogin,
              initialData: true,
              builder: (context, snapshot) {
                if (snapshot.data) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return _body();
              }),
        ],
      )),
    );
  }
}
