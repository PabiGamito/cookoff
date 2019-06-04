import 'package:bloc/bloc.dart';
import 'package:cookoff/models/user.dart';

class AuthBloc extends Bloc<User, User> {
  static final AuthBloc instance = AuthBloc._internal();

  AuthBloc._internal();

  @override
  User get initialState => NullUser();

  @override
  Stream<User> mapEventToState(User event) async* {
    yield event;
  }
}

class LoadingAuthBloc extends Bloc<bool, bool> {
  static final LoadingAuthBloc instance = LoadingAuthBloc._internal();

  LoadingAuthBloc._internal();

  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(bool event) async* {
    yield event;
  }
}
