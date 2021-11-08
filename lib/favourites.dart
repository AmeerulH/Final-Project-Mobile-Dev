import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/about_page.dart';
import 'package:sign_up_flutter/class/user.dart';
import 'package:sign_up_flutter/create_post_page.dart';
import 'package:sign_up_flutter/cubit/main_cubit.dart';
import 'package:sign_up_flutter/post_details.dart';
import 'package:sign_up_flutter/posts_page.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:characters/characters.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key, required this.name, required this.posts})
      : super(key: key);
  final String name;
  final dynamic posts;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => MainCubit(),
      child: FavPage(name: name, posts: posts),
    ));
  }
}

class FavPage extends StatefulWidget {
  const FavPage({Key? key, required this.name, required this.posts})
      : super(key: key);

  final String name;
  final dynamic posts;

  @override
  State<FavPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FavPage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List posts = [];
  List favourites = [];

  // final _db = Localstore.instance;
  // final _items = <dynamic, User>{};
  // StreamSubscription<Map<dynamic, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    setState(() {
      posts = widget.posts;
    });

    // _subscription = _db.collection('favourites').stream.listen((event) {
    //   setState(() {
    //     final item = User.fromMap(event);
    //     _items.putIfAbsent(item.author, () => item);
    //     // final _emails = _items.forEach((key, value) {})
    //   });
    // });
    // if (kIsWeb) _db.collection('favourites').stream.asBroadcastStream();

    // print(_items);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostPageFinal(name: widget.name)),
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            posts.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    // controller: _scrollController,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0XFFEE9B00),
                        ),
                        height: 120,
                        child: GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Image(
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
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
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
                                                            posts[index]["title"]
                                                                        .length >
                                                                    20
                                                                ? '${posts[index]["title"].toString().characters.take(20)}...'
                                                                : '${posts[index]["title"]}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            posts[index]["description"]
                                                                        .length >
                                                                    20
                                                                ? '${posts[index]["description"].toString().characters.take(20)}...'
                                                                : '${posts[index]["description"]}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                                    FontWeight
                                                                        .bold),
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
                    // itemCount: _listCount <= posts.length
                    //     ? _listCount
                    //     : posts.length)
                  ))
                : Container()
          ],
        ),
      ),
    );
  }
}
