import 'package:a/database/category_provider.dart';
import 'package:a/database/db_helper.dart';
import 'package:a/database/question_provider.dart';
import 'package:a/model/user_answer_model.dart';
import 'package:a/state/state_manager.dart';
import 'package:a/utils/utils.dart';
import 'package:a/widgets/question_body.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReadModePage extends StatefulWidget {
  MyReadModePage({Key? key, required this.title}) : super(key: key);
  final String? title;

  @override
  State<StatefulWidget> createState() => _MyReadModePageState();
}

class _MyReadModePageState extends State<MyReadModePage> {
  late SharedPreferences prefs;
  int? indexPage =0;
  CarouselController buttonCarouselController = CarouselController();
  List<UserAnswer> userAnswers = <UserAnswer>[];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      indexPage = await prefs.getInt(
          '${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}') ?? 0;
      print('Bu sayfayı kaydet: ${indexPage}');
      Future.delayed(Duration(milliseconds: 500))
          .then((value) => buttonCarouselController.animateToPage(indexPage == null ? 0: indexPage));
    });
  }

  @override
  Widget build(BuildContext context) {

    var questionModule = context.read(questionCategoryState).state;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(questionModule.name!),
            leading: GestureDetector(
              onTap: () => showCloseDialog(questionModule),
              child: Icon(Icons.arrow_back),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: FutureBuilder<List<Question>?>(
              future: getQuestionByCategory(questionModule.ID),
              builder: (context, snapshot){

                if (snapshot.hasError)
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                else if (snapshot.hasData) {
                  if (snapshot.data!.length > 0)
                    {
                      return Container(margin: const EdgeInsets.all(4.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4, top: 10),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              QuestionBody(context: context,
                                  userAnswers: userAnswers,
                                  carouselController: buttonCarouselController,
                                  questions: snapshot.data!,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(onPressed: () => showAnswer(context), child: Text('Cevabı Göster'))
                                ],
                              )

                            ],),
                          ),
                        ),
                      ),);
                    }
                  //else return Center(child: Text('Bu kategoride soru yok'),);


                } //else
                  else return Center(child: Text('Bu kategoride hiç soru yok'),);
                  return Center(
                    child: CircularProgressIndicator(),
                  );

              },
            ),
          ),
        ),
        onWillPop: () async {
          showCloseDialog(questionModule);
          return true;
        });
  }

  showCloseDialog(Category questionModule) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('Geri Dön'),
              content: Text('Geri Dönmek istiyor musunuz?'),
              actions: [
                TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();

                      Navigator.pop(context);
                    },
                    child: Text('Hayır')),
                TextButton(
                    onPressed: () {
                      //prefs.setInt(
                        //  '${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}',
                          //context.read(currentReadPage).state);

                      context.read(isEnableShowAnswer).state = false;
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    child: Text('Evet')),
              ],
            ));
  }

  Future<List<Question>?> getQuestionByCategory(int? id) async{
    var db = await copyDB();
    var result = await QuestionProvider().getQuestionByCategoryId(db, id!);
    return result;
  }
}
