import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
import 'package:sign_up_flutter/posts_page.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:sign_up_flutter/class/user.dart';

import 'cubit/main_cubit.dart';

class CreatePageFinal extends StatelessWidget {
  const CreatePageFinal({Key? key, required this.name}) : super(key: key);
  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => MainCubit(),
      child: CreatePostPage(name: name),
    ));
  }
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<CreatePostPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  String Name = '';
  String title = '';
  String description = '';
  String url = '';
  List posts = [];

  void createPost(title, description, url) {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
      channel.sink.close();
    });

    channel.sink.add('{"type": "sign_in", "data": {"name": "${widget.name}"}}');
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$url"}}');
  }

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post Page'),
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
      body: ListView(
        children: [
          BlocBuilder<MainCubit, dynamic>(
              bloc: context.read<MainCubit>(),
              builder: (context, state) {
                return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: const Image(
                              image: NetworkImage(
                                  'https://dbdzm869oupei.cloudfront.net/img/photomural/preview/49057.png')),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Title',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Enter Title: ',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                                onChanged: (String? value) {
                                  setState(() {
                                    title = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Enter a description: ',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                                onChanged: (String? value) {
                                  setState(() {
                                    description = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Image URL',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Enter Image URL: ',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a url';
                                  }
                                  return null;
                                },
                                onChanged: (String? value) {
                                  setState(() {
                                    url = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(150, 20),
                                  primary: const Color(
                                    0XFFAE2012,
                                  )),
                              child: const Text('Submit'),
                              onPressed: _formKey.currentState?.validate() ??
                                      false
                                  ? () {
                                      // print(
                                      //     '${widget.name}, $title, $description, $url');
                                      // createPost(title, description, url);
                                      context.read<MainCubit>().openChannel();
                                      context
                                          .read<MainCubit>()
                                          .login(widget.name);
                                      context
                                          .read<MainCubit>()
                                          .createPost(title, description, url);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Successfully Posted!'),
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostPageFinal(
                                                name: widget.name)),
                                      );
                                    }
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(150, 20),
                                  primary: const Color(0XFFEE9B00),
                                ),
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostPageFinal(name: widget.name)),
                                  );
                                }),
                          ],
                        ))
                      ],
                    ));
              }),
        ],
      ),
    );
  }
}
