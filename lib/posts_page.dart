import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/create_post_page.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

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

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });

      print(posts);
      channel.sink.close();
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Page'),
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_box_rounded),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreatePostPage()),
                              );
                            },
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.lightBlue,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.sort_by_alpha),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                              Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.lightBlue,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.favorite),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              posts.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                color: Colors.amberAccent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                '${posts[index]["title"]}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // Text(
                                              //   '${posts[index]["description"]}',
                                              //   style: const TextStyle(
                                              //       fontWeight:
                                              //           FontWeight.bold),
                                              // ),
                                              // Text(
                                              //   'Date: ${posts[index]["date"]}',
                                              //   style: const TextStyle(
                                              //       fontWeight:
                                              //           FontWeight.bold),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
