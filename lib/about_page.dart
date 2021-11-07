import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/posts_page.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key, required this.name}) : super(key: key);

  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(name: name));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    builder: (context) => PostPageFinal(name: widget.name)),
              );
            },
          )
        ],
        title: const Text('About Page'),
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
          margin:
              const EdgeInsets.only(top: 40, right: 20, bottom: 40, left: 20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: const [
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: Row(
                        children: const [
                          Flexible(
                            child: Text(
                              'This project was made for the Mobile Development team within Deriv. The goal was to develop an app that could call an API, where we can receive posts, post posts and delete posts. These posts have a title, a description and an image url.',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 10),
                      Container(
                          child: Row(
                        children: const [
                          Flexible(
                            child: Text(
                              'This app has 5 different pages. A User Name Page, a Create Post Page, a Posts Page, a Posts Details Page, and finally an About Page',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 10),
                      Container(
                          child: Row(
                        children: const [
                          Flexible(
                            child: Text(
                              'This app should be fully functional, however, not everything will be fulfilled. Hope you enjoy the application!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
