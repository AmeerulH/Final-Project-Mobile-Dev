import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/about_page.dart';
import 'package:sign_up_flutter/class/user.dart';
import 'package:sign_up_flutter/create_post_page.dart';
import 'package:sign_up_flutter/cubit/main_cubit.dart';
import 'package:sign_up_flutter/favourites.dart';
import 'package:sign_up_flutter/post_details.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:characters/characters.dart';

class PostPageFinal extends StatelessWidget {
  const PostPageFinal({Key? key, required this.name}) : super(key: key);
  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => MainCubit(),
      child: PostPage(name: name),
    ));
  }
}

class PostPage extends StatefulWidget {
  const PostPage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<PostPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PostPage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List posts = [];
  List favourites = [];
  bool sortType = false;
  dynamic test;

  // final _db = Localstore.instance;
  // final _items = <dynamic, User>{};
  // StreamSubscription<Map<dynamic, dynamic>>? _subscription;

  var _scrollController = ScrollController();
  var _listCount = 15;

  // late final AnimationController _controller =
  //     AnimationController(duration: const Duration(seconds: 2), vsync: this);

  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.easeIn,
  // );

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
        posts.sort((b, a) {
          var aDate = a['date'];
          var bDate = b['date'];
          return aDate.compareTo(bDate);
        });
      });
      // print(posts);
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  // void deletePost(name, id) {
  //   channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
  //   channel.sink.add('{"type": "delete_post", "data": {"postId": "$id"}}');
  // }

  void sortAlpha() {
    if (sortType == true) {
      setState(() {
        posts.sort((a, b) {
          var aTitle = a['title'];
          var bTitle = b['title'];
          return aTitle.compareTo(bTitle);
        });
        sortType = false;
      });
    } else if (sortType == false) {
      setState(() {
        posts.sort((b, a) {
          var aTitle = a['title'];
          var bTitle = b['title'];
          return aTitle.compareTo(bTitle);
        });
        sortType = true;
      });
    }
  }

  void getData() async {
    // posts = await BlocProvider.of<MainCubit>(context).openChannel()['data']
    //     ['posts'];
    BlocProvider.of<MainCubit>(context).openChannel();
    BlocProvider.of<MainCubit>(context).getPosts();
  }

  void scrollDown() {
    final double end = _scrollController.position.maxScrollExtent;

    _scrollController.animateTo(end,
        duration: Duration(seconds: 5), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    // getData();
    setState(() {});
    getPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          setState(() {
            _listCount += 10;
          });
          // print("reach end " + _listCap.toString());
        }
      }
    });

    // _subscription = _db.collection('favourites').stream.listen((event) {
    //   setState(() {
    //     final item = User.fromMap(event);
    //     _items.putIfAbsent(item.author, () => item);
    //     // final _emails = _items.forEach((key, value) {})
    //   });
    // });
    // if (kIsWeb) _db.collection('favourites').stream.asBroadcastStream();
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
    _scrollController.dispose();
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
                  Color(0xFF9B2226),
                  Color(0XFFEE9B00),
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
                      Container(
                        child: Row(
                          children: [
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color(0XFF001219),
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
                                        builder: (context) =>
                                            CreatePageFinal(name: widget.name)),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color(0XFF001219),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.settings),
                                color: Colors.white,
                                onPressed: () {
                                  channel.sink.close();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AboutPage(name: widget.name)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(),
                            //   onPressed: () {
                            //     scrollDown();
                            //   },
                            //   child: const Text('Latest'),
                            // ),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color(0XFF001219),
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
                                color: Color(0XFF001219),
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.favorite),
                                color: const Color(0XFFAE2012),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FavouritesPage(
                                              name: widget.name,
                                              posts: favourites,
                                            )),
                                  );
                                },
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
            BlocBuilder<MainCubit, dynamic>(
                bloc: context.read<MainCubit>(),
                builder: (context, state) {
                  return posts.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0XFFEE9B00),
                                    // gradient: const LinearGradient(
                                    //     colors: [
                                    //       Color(0xFF9B2226),
                                    //       Color(0XFFEE9B00),
                                    //     ],
                                    //     begin: FractionalOffset(0.0, 1.5),
                                    //     end: FractionalOffset(0.0, 0.0),
                                    //     stops: [0.0, 1.0],
                                    //     tileMode: TileMode.clamp),
                                  ),
                                  height: 120,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(posts[index]['author']);
                                      channel.sink.close();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostDetails(
                                                title: posts[index]['title'],
                                                description: posts[index]
                                                    ['description'],
                                                url: posts[index]['image'],
                                                name: widget.name)),
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
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: Card(
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Image(
                                                              image: NetworkImage(Uri.parse(posts[index]
                                                                              [
                                                                              'image'])
                                                                          .isAbsolute &&
                                                                      posts[index]
                                                                          .containsKey(
                                                                              'image')
                                                                  ? '${posts[index]['image']}'
                                                                  : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
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
                                                                      posts[index]["title"].length >
                                                                              20
                                                                          ? '${posts[index]["title"].toString().characters.take(20)}...'
                                                                          : '${posts[index]["title"]}',
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      posts[index]["description"].length >
                                                                              20
                                                                          ? '${posts[index]["description"].toString().characters.take(20)}...'
                                                                          : '${posts[index]["description"]}',
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
                                                                  color: const Color(
                                                                      0XFF001219),
                                                                  onPressed: widget
                                                                              .name ==
                                                                          posts[index]
                                                                              [
                                                                              'author']
                                                                      ? () {
                                                                          context
                                                                              .read<MainCubit>()
                                                                              .openChannel();
                                                                          context
                                                                              .read<MainCubit>()
                                                                              .login(widget.name);
                                                                          context
                                                                              .read<MainCubit>()
                                                                              .delete(posts[index]['_id']);
                                                                          channel
                                                                              .sink
                                                                              .close();
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => PostPageFinal(name: widget.name)),
                                                                          );
                                                                        }
                                                                      : null),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Ink(
                                                              child: IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .favorite),
                                                                color: favourites
                                                                        .contains(posts[
                                                                            index])
                                                                    ? const Color(
                                                                        0XFFAE2012)
                                                                    : Colors
                                                                        .white,
                                                                onPressed: () {
                                                                  // final item = User(
                                                                  //     author: widget
                                                                  //         .name,
                                                                  //     posts: posts[
                                                                  //         index]);
                                                                  // item.save();
                                                                  // _items.putIfAbsent(
                                                                  //     item
                                                                  //         .author,
                                                                  //     () =>
                                                                  //         item);

                                                                  if (favourites
                                                                      .contains(
                                                                          posts[
                                                                              index])) {
                                                                    setState(
                                                                        () {
                                                                      favourites
                                                                          .remove(
                                                                              posts[index]);
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      favourites.add(
                                                                          posts[
                                                                              index]);
                                                                    });
                                                                  }

                                                                  print(
                                                                      favourites);
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
                              },
                              itemCount: _listCount <= posts.length
                                  ? _listCount
                                  : posts.length))
                      : Container();
                })
          ],
        ),
      ),
    );
  }
}

// extension ExtTodo on User {
//   Future save() async {
//     final _db = Localstore.instance;
//     return _db.collection('favourites').doc(author).set(toMap());
//   }

//   Future delete() async {
//     final _db = Localstore.instance;
//     return _db.collection('favourites').doc(author).delete();
//   }
// }
