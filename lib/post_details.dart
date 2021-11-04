import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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

  void login(name) {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        Name = decodedMessage['type'];
      });
      channel.sink.close();
    });

    channel.sink.add('{"type": "sign_in","data": {"name": $name}');
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
          title: const Text('Details'),
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
        body: Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.error,
                        ),
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
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: const Text('Submit'),
                        // style: ElevatedButton.styleFrom(
                        //     primary: _formKey.currentState?.validate() ?? false
                        //         ? Colors.blueAccent
                        //         : Colors.blueGrey),
                        onPressed: _formKey.currentState?.validate() ?? false
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Successfully Signed Up!'),
                                  ),
                                );
                                login(Name);
                                // final id = Localstore.instance
                                //     .collection('users')
                                //     .doc()
                                //     .id;
                                // final item = User(
                                //   id: id,
                                //   name: Name,
                                // );
                                // item.save();
                                // _items.putIfAbsent(item.id, () => item);
                                // _items.forEach((key, value) {
                                //   // ignore: avoid_print
                                //   print(
                                //       'ID: ${value.id}, Name: ${value.name}, Email: ${value.email}, Password: ${value.password}');
                                // });
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           HomePage(user: item)),
                                // );
                              }
                            : null,
                      ))
                ],
              )),
        ));
  }
}
