import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

import '../../data/repository.dart';
import '../form/form_store.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // repository instance
  final Repository _repository;

  // store for handling form errors
  final FormErrorStore formErrorStore = FormErrorStore();

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  // bool to check if current user is logged in
  bool isLoggedIn = false;

  // constructor:---------------------------------------------------------------
  _UserStore(Repository repository) : this._repository = repository {
    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    repository.isLoggedIn.then((value) {
      this.isLoggedIn = value;
    });
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<bool> emptyLoginResponse =
      ObservableFuture.value(false);

  // store variables:-----------------------------------------------------------
  @observable
  User? user;

  @observable
  bool success = false;

  @observable
  ObservableFuture<bool> loginFuture = emptyLoginResponse;

  static ObservableFuture<User?> emptyUserResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<User?> fetchUserFuture =
      ObservableFuture<User?>(emptyUserResponse);

  @computed
  bool get loading => fetchUserFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future login(String email, String password) async {
    final future = _repository.login(email, password);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value) {
        print('[value]  $value');
        _repository.saveIsLoggedIn(true);
        this.isLoggedIn = true;
        this.success = true;
      } else {
        print('failed to login');
      }
    }).catchError((e) {
      print(e);
      this.isLoggedIn = false;
      this.success = false;
      throw e;
    });
  }

  @action
  Future signup(User user) async {
    final future = _repository.signup(user);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value) {
        print('[value]  $value');
        _repository.saveIsLoggedIn(true);
        this.isLoggedIn = true;
        this.success = true;
      } else {
        print('failed to sign up');
      }
    }).catchError((e) {
      print(e);
      this.isLoggedIn = false;
      this.success = false;
      throw e;
    });
  }

  logout() {
    this.isLoggedIn = false;
    _repository.saveIsLoggedIn(false);
  }

  @action
  Future getUser() async {

    final future = _repository.getUser();
    fetchUserFuture = ObservableFuture(future);

    future.then((user) {
      this.user =  user;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return user;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
