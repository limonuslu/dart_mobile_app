
import 'package:a/screens/home_page.dart';
import 'package:a/screens/question_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/read_mode.dart';
import 'screens/show_result.dart';
import 'screens/test_mode.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/homePage": (context) => MyCategoryPage(title: 'Kategoriler' ,),
        "/readMode": (context) => MyReadModePage(title: '',),
        "/testMode": (context) => MyTestModePage(title: '',),
        "/showResult": (context) => MyResultPage(title: '',),
        "/questionDetail": (context) => MyQuestionDetailPage(title: '',),
      },
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Kategoriler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/homePage");
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

      ),

    );
  }
}
