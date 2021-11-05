import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<String> {
  MainCubit() : super('');

  void login(name) {
    emit(name);
    print(state);
  }

  String getName() {
    return state;
  }
}
