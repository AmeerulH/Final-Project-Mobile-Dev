import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/posts_page.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({
    Key? key,
    required this.title,
    required this.description,
    required this.url,
    required this.name,
  }) : super(key: key);

  final String title;
  final String description;
  final String url;
  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
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
                    builder: (context) => PostPageFinal(name: name)),
              );
            },
          )
        ],
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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Image(
              image: NetworkImage(Uri.parse(url).isAbsolute
                  ? url
                  : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    ));
  }
}
