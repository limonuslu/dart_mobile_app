import 'package:a/database/question_provider.dart';
import 'package:a/model/user_answer_model.dart';
import 'package:a/state/state_manager.dart';
import 'package:a/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class QuestionBody extends StatelessWidget {
  QuestionBody(
      {Key? key,
      required this.context,
      required this.userAnswers,
      required this.carouselController,
      required this.questions})
      : super(key: key);

  BuildContext context;
  List<UserAnswer> userAnswers;
  CarouselController carouselController;
  List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
        items: questions
            .asMap()
            .entries
            .map((e) => Builder(
                  builder: (context) {
                    return Consumer(
                      builder: (context, watch, _) {
                        var userAnswerState = watch(userAnswerSelected).state;
                        var isShowAnswer = watch(isEnableShowAnswer).state;

                        return Column(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                AutoSizeText(context.read(isTestMode).state
                                    ? 'No ${e.key + 1}:${e.value.questionText}'
                                    : 'No${e.value.questionID}:${e.value.questionText}'), // Question
                                Visibility(
                                    visible: (e.value.isImageQuestion == null ||
                                            e.value.isImageQuestion == 0
                                        ? false
                                        : true),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15 *
                                                3,
                                        child: e.value.isImageQuestion == 0
                                            ? Container()
                                            : Image.network(
                                                '${e.value.questionImage}',
                                                fit: BoxFit.fill,
                                              ))), // If question is image, show , it
                                Expanded(
                                    child: ListTile(
                                  title: AutoSizeText(
                                    '${e.value.answerA}',
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == 'A'
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                    value: 'A',
                                    groupValue: getGroupValue(
                                        isShowAnswer, e, userAnswerState),
                                    onChanged: (value) =>
                                        setUserAnswer(context, e, value),
                                  ),
                                )), // Answer A
                                Expanded(
                                    child: ListTile(
                                  title: AutoSizeText(
                                    '${e.value.answerB}',
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == 'B'
                                                ? Colors.red
                                                : Colors.grey
                                                : Colors.black),
                                  ),
                                  leading: Radio(
                                    value: 'B',
                                    groupValue: getGroupValue(
                                        isShowAnswer, e, userAnswerState),
                                    onChanged: (value) =>
                                        setUserAnswer(context, e, value),
                                  ),
                                )), // Answer B
                                Expanded(
                                    child: ListTile(
                                  title: AutoSizeText(
                                    '${e.value.answerC}',
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == 'C'
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                    value: 'C',
                                    groupValue: getGroupValue(
                                        isShowAnswer, e, userAnswerState),
                                    onChanged: (value) =>
                                        setUserAnswer(context, e, value),
                                  ),
                                )), // Answer C
                                Expanded(
                                    child: ListTile(
                                  title: AutoSizeText(
                                    '${e.value.answerD}',
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == 'D'
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                    value: 'D',
                                    groupValue: getGroupValue(
                                        isShowAnswer, e, userAnswerState),
                                    onChanged: (value) =>
                                        setUserAnswer(context, e, value),
                                  ),
                                )), // Answer D
                              ],
                            )),
                          ],
                        );
                      },
                    );
                  },
                ))
            .toList(),
        options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            initialPage: 0,
            height: MediaQuery.of(context).size.height / 5 * 3,
            onPageChanged: (page, _) {
              context.read(currentReadPage).state = page;
              context.read(isEnableShowAnswer).state = false;
              context.read(isEnableShowAnswer).state = false;
            }));
  }

  getGroupValue(bool isShowAnswer, MapEntry<int, Question> e, UserAnswer userAnswerState) {
    return isShowAnswer ? e.value.correctAnswer : (context.read(isTestMode).state ?
    context.read(userListAnswer).state[e.key].answered : '');
  }
}
