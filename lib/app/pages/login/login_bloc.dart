import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:teddy_todo/app/shared/blocs/auth_bloc.dart';


enum LoginStatus {
  IDLE,
  LOADING,
  ERROR,
  GET_USER,
  SUCCESS,
}

class LoginBloc extends BlocBase {

  final AuthBloc _authBloc;

  String email;
  String pass;

  final _login$ = PublishSubject();
  Observable<LoginStatus> get loginStatus => _login$.stream.switchMap(_loginStream).shareValueSeeded(LoginStatus.IDLE);


  Stream<LoginStatus> _loginStream(v) async* {
    try{
      yield LoginStatus.LOADING;
      await _authBloc.login(email, pass);
      yield LoginStatus.GET_USER;
      await _authBloc.getUser();
      yield LoginStatus.SUCCESS;
    } catch (e) {
      print(e);
      yield LoginStatus.ERROR;
    }
  }

  LoginBloc(this._authBloc);

  login() {
   _login$.add(true);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _login$.close();
    super.dispose();
  }
}
