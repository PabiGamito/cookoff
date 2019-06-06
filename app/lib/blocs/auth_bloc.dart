import 'package:bloc/bloc.dart';

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
