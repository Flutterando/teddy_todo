import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teddy_todo/app/shared/models/token_model.dart';
import 'package:teddy_todo/app/shared/models/user_model.dart';
import 'package:teddy_todo/app/shared/repositories/auth_repository.dart';
import 'package:teddy_todo/app/shared/services/credentials_service.dart';
import 'package:teddy_todo/app/shared/services/local_storage_service.dart';

class AuthBloc extends BlocBase {
  final AuthRepository _repository;
  final LocalStorageService localStorage;
  final CredentialsService credentialsService;

  final _user$ = BehaviorSubject<UserModel>.seeded(null);
  Sink<UserModel> get userIn => _user$.sink;
  Observable<UserModel> get userOut => _user$.stream
      .asyncMap((v) async {
        if (v == null) {
          return await localStorage.get<UserModel>(LocalStorageService.USER,
              construct: (v) => UserModel.fromJson(v));
        } else {
          return v;
        }
      })
      .share()
      .cast<UserModel>();

  final _login$ = BehaviorSubject<bool>.seeded(null);
  Sink<bool> get loginFlux => _login$.sink;

  Observable<bool> get isLogin => _login$.stream.asyncMap((v) async {
        if (v == null) {
          return (await localStorage.get(LocalStorageService.TOKEN)) != null;
        } else {
          return v;
        }
      }).distinct((v1, v2) => v1 == v2) .share();

  TokenModel token;
  AuthBloc(this._repository, this.localStorage, this.credentialsService);

  Future<bool> login(String email, String pass) async {
    String credentials = credentialsService.returnCredencial(email, pass);
    token = await _repository.getToken(credentials);
    await saveToken(token);
    _login$.add(true);
    return true;
  }

  Future getUser() async {
    UserModel model = await _repository.getUser();
    await localStorage.put(LocalStorageService.USER, model.toJson());
    _user$.add(model);
  }

  Future logoff() async {
    await localStorage.removeAll();
    _user$.add(null);
    _login$.add(false);
  }

  Future<TokenModel> refreshToken() async {
    TokenModel token = await loadToken();
    return await _repository.getToken(token.credentials);
  }

  Future<TokenModel> loadToken() async {
    if (token == null) {
      token =
          await localStorage.get(LocalStorageService.TOKEN, construct: (data) {
        return TokenModel.fromJson(data);
      });
    }
    return token;
  }

  Future<bool> saveToken(TokenModel token) async {
    if (token == null) {
      return false;
    } else {
      await localStorage.put(LocalStorageService.TOKEN, token.toJson());
      return true;
    }
  }

  @override
  void dispose() {
    _user$.close();
    _login$.close();
    super.dispose();
  }
}
