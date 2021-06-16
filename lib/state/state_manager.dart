import 'package:a/database/category_provider.dart';
import 'package:a/database/question_provider.dart';
import 'package:a/model/user_answer_model.dart';
import 'package:flutter_riverpod/all.dart';

final categoryListProvider = StateNotifierProvider((ref) => new CategoryList([]));
final questionCategoryState = StateProvider((ref) => new Category());
final isTestMode = StateProvider((ref) => false);
final currentReadPage = StateProvider((ref) => 0);
final userAnswerSelected = StateProvider((ref) => new UserAnswer());
final isEnableShowAnswer = StateProvider((ref) => false);
final userListAnswer = StateProvider((ref) => <UserAnswer>[]);
final userViewQuestionState = StateProvider((ref) => new Question());