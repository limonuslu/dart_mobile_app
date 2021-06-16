import 'package:a/const/const.dart';
import 'package:a/database/db_helper.dart';
import 'package:a/database/question_provider.dart';
import 'package:a/model/user_answer_model.dart';
import 'package:a/state/state_manager.dart';
import 'package:a/widgets/count_down.dart';
import 'package:a/widgets/question_body.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class MyTestModePage extends StatefulWidget {
  MyTestModePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _MyTestModePageState();
}

class _MyTestModePageState extends State<MyTestModePage>
    with SingleTickerProviderStateMixin {
  CarouselController carouselController = new CarouselController();
  List<UserAnswer> userAnswers = <UserAnswer>[];

  AnimationController? _controller;
  @override
  void dispose() {
    // TODO: implement dispose

    if (_controller!.isAnimating || _controller!.isCompleted)
      _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: limitTime));
    _controller!.addListener(() {
      if (_controller!.isCompleted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/showResult");
      }
    });
    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Test'),
            leading: GestureDetector(
                onTap: () => showCloseExamDialog(),
                child: Icon(Icons.arrow_back)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                    title: Text('Testin'),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.0,
                                        padding: const EdgeInsets.all(4.0),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                        children: context
                                            .read(userListAnswer)
                                            .state
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: AutoSizeText(
                                                'Soru ${e.key + 1}:${e.value.answered == null || e.value.answered!.isEmpty ? ' ' : e.value.answered}',
                                                style: TextStyle(
                                                    fontWeight: (e.value
                                                                    .answered !=
                                                                null &&
                                                            !e.value.answered!
                                                                .isEmpty)
                                                        ? FontWeight.bold
                                                        : FontWeight.normal),
                                                maxLines: 1,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              carouselController
                                                  .animateToPage(e.key);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Kapat')),
                                    ],
                                  ));
                        },
                        child: Column(
                          children: [Icon(Icons.note), Text('Cevaplarım')],
                        )),
                    Countdown(
                        animation: StepTween(begin: limitTime, end: 0)
                            .animate(_controller!)),
                    TextButton(
                        onPressed: () {
                          showFinishDialog();
                        },
                        child: Column(
                          children: [Icon(Icons.done), Text('Bitir')],
                        )),
                  ],
                ),
                FutureBuilder<List<Question>?>(
                    future: getQuestion(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      else if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Card(
                            elevation: 8,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 4, top: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    QuestionBody(
                                      context: context,
                                      userAnswers: userAnswers,
                                      carouselController: carouselController,
                                      questions: snapshot.data!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    })
              ],
            ),
          ),
        ),
        onWillPop: () async {
          showCloseExamDialog();
          return true;
        });
  }

  void showCloseExamDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('Kapat'),
              content: Text('Sınavı kapatmak istiyor musunuz?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Hayır')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    child: Text('Evet')),
              ],
            ));
  }

  Future<List<Question>?> getQuestion() async {
    var db = await copyDB();
    var result = await QuestionProvider().getQuestions(db);
    userAnswers.clear();
    result!.forEach((element) {
      userAnswers.add(new UserAnswer(
          questionId: element.questionID, answered: '', isCorrect: false));
    });
    context.read(userListAnswer).state = userAnswers;
    return result;
  }

  void showFinishDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('Bitir'),
              content: Text('Sınavı bitirmek istiyor musunuz?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Hayır')),
                TextButton(
                    onPressed: () {
                      context.read(userListAnswer).state = userAnswers;
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacementNamed("/showResult");
                    },
                    child: Text('Evet')),
              ],
            ));
  }
}
