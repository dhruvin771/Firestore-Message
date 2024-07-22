import 'package:chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAfwPUC_wNipOEBq0UONqghDnN8czmEeK8',
          appId: '1:455609282707:android:43c6e3104558c6f6ff9d66',
          projectId: 'chatapp-e283c',
          messagingSenderId: 'ok',
          storageBucket: "chatapp-e283c.appspot.com"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => ChatScreen('Smiley')));
                  /*CollectionReference chat =
                      FirebaseFirestore.instance.collection('chat');

                  chat
                      .add({
                        'message': 'Acme Corp',
                        'time': DateTime.now().millisecondsSinceEpoch
                      })
                      .then((value) => print("User Added"))
                      .catchError(
                          (error) => print("Failed to add user: $error"));*/
                },
                child: const Text('Smiley')),
            ElevatedButton(
                onPressed: () {
                  //fetchAndPrintChatData();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => ChatScreen('Happy')));
                },
                child: const Text('Happy'))
          ],
        ),
      ),
    );
  }

  void fetchAndPrintChatData() {
    CollectionReference chat = FirebaseFirestore.instance.collection('chat');

    chat.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      });
    }).catchError((error) => print("Failed to fetch chat data: $error"));
  }
}
