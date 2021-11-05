import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

class MainCubit extends Cubit<String> {
  MainCubit() : super('');
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  void login(name) {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
    });

    channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
    emit(name);
  }

  void getPosts() {
    channel.sink.add('{"type": "get_posts"}');
  }

  String getName() {
    return state;
  }
}
