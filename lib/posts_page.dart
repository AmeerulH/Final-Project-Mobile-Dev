import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_up_flutter/create_post_page.dart';
import 'package:sign_up_flutter/cubit/main_cubit.dart';
import 'package:sign_up_flutter/post_details.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:characters/characters.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List posts = [];
  String sortType = 'asc';

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });

      // print(posts);
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  void deletePost(name, id) {
    channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$id"}}');
  }

  void sortAlpha() {
    if (sortType == 'asc') {
      setState(() {
        posts.sort((a, b) => a.value['title'].compareTo(b.value['title']));
      });
      sortType == 'dsc';
    } else if (sortType == 'dsc') {
      if (sortType == 'asc') {
        setState(() {
          posts.sort((a, b) => b.value['title'].compareTo(a.value['title']));
        });
      }
      sortType == 'asc';
    }
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                            channel.sink.close();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreatePostPage()),
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
                                onPressed: () {
                                  sortAlpha();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
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
            BlocBuilder<MainCubit, String>(
                bloc: context.read<MainCubit>(),
                builder: (context, state) {
                  return posts.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    color: Colors.amberAccent,
                                  ),
                                  height: 120,
                                  child: GestureDetector(
                                    onTap: () {
                                      channel.sink.close();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostDetails(
                                                title: posts[index]['title'],
                                                description: posts[index]
                                                    ['description'],
                                                url: posts[index]['image'])),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Image(
                                                          image: NetworkImage(Uri.parse(
                                                                          posts[index]
                                                                              [
                                                                              'image'])
                                                                      .isAbsolute &&
                                                                  posts[index]
                                                                      .containsKey(
                                                                          'image')
                                                              ? '${posts[index]['image']}'
                                                              : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                                          height: 100,
                                                          width: 100,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${posts[index]["title"]}',
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      '${posts[index]["description"]}',
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 50,
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${posts[index]["date"].toString().characters.take(10)}',
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Ink(
                                                              child: IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_forever),
                                                                color: Colors
                                                                    .black,
                                                                onPressed: () {
                                                                  print(
                                                                      'delete');
                                                                  deletePost(
                                                                      state,
                                                                      posts[index]
                                                                          [
                                                                          '_id']);
                                                                  print(posts[
                                                                          index]
                                                                      ['_id']);
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Ink(
                                                              child: IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .favorite),
                                                                color: Colors
                                                                    .black,
                                                                onPressed: () {
                                                                  print(
                                                                      'favourite');
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }))
                      : Container();
                })
          ],
        ),
      ),
    );
  }
}
