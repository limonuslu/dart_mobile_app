import 'package:a/model/user_answer_model.dart';
import 'package:a/database/question_provider.dart';
import 'package:a/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';

void setUserAnswer(BuildContext context, MapEntry<int, Question> e, value) {
  context
      .read(userListAnswer)
      .state[e.key] = context
      .read(userAnswerSelected)
      .state =
  new UserAnswer(
          questionId: e.value.questionID,
          answered: value,
          isCorrect: value
              .toString()
              .isNotEmpty ? value.toString().toLowerCase() ==
              e.value.correctAnswer!.toLowerCase() : false);
}

void showAnswer (BuildContext context)
{
  context.read(isEnableShowAnswer).state = true;
}
