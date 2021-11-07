import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_up_flutter/create_post_page.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/posts_page.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

import 'cubit/main_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => MainCubit(),
      child: const MyHomePage(),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  String Name = '';
  List posts = [];
  final _db = Localstore.instance;
  final _items = <String, User>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  void loginChannel() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
      // setState(() {
      //   Name = decodedMessage['type'];
      // });
      // channel.sink.close();
    });

    // channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
  }

  @override
  void initState() {
    super.initState();
    // getData();
    //connect to the database
    _subscription = _db.collection('users').stream.listen((event) {
      setState(() {
        final item = User.fromMap(event);
        _items.putIfAbsent(item.id, () => item);
        // final _emails = _items.forEach((key, value) {})
      });
    });
    if (kIsWeb) _db.collection('users').stream.asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up page'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFF3366FF),
                    Color(0xFF00CCFF),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: const Image(
                        image: NetworkImage(
                            'https://pbs.twimg.com/media/FBvRFA7XEAI6ogm.jpg'),
                      )),
                  BlocBuilder<MainCubit, dynamic>(
                      bloc: context.read<MainCubit>(),
                      builder: (context, state) {
                        return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Username ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20, bottom: 10),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle),
                                      hintText: 'Username: ',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Username: ';
                                      }
                                      return null;
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        Name = value!;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      child: const Text('Submit'),
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(300, 20)),
                                      onPressed:
                                          _formKey.currentState?.validate() ??
                                                  false
                                              ? () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Successfully Signed Up!'),
                                                    ),
                                                  );
                                                  context
                                                      .read<MainCubit>()
                                                      .openChannel();
                                                  context
                                                      .read<MainCubit>()
                                                      .login(Name);
                                                  // login(Name);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PostPageFinal(
                                                                name: Name)),
                                                  );
                                                }
                                              : null,
                                    ),
                                  ],
                                ))
                              ],
                            ));
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
