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
