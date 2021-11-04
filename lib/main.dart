import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_up_flutter/create_post_page.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/posts_page.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage(title: 'Hhello'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

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

    channel.sink.add('{"type": "sign_in","data": {"name": "$name"}');
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

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PostPage()),
                                );
                              }
                            : null,
                      ))
                ],
              )),
        ));
  }
}

bool findEmail(arr, email) {
  bool b = false;
  arr.forEach((key, value) => {
        if (value.email == email) {b = true} else {b = false}
      });

  return b;
}

extension ExtTodo on User {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('users').doc(id).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('users').doc(id).delete();
  }
}