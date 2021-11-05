import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<String> {
  MainCubit() : super('');

  void login(name) {
    emit(name);
    print(state);
  }

  void getName() {
    emit(state);
  }
}
