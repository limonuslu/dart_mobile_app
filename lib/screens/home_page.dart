import 'package:a/database/category_provider.dart';
import 'package:a/database/db_helper.dart';
import 'package:a/state/state_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class MyCategoryPage extends StatefulWidget {
  MyCategoryPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<Category>?>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text('${snapshot.error}'),
              );
            else if (snapshot.hasData) {
              Category category = new Category();
              category.ID = -1;
              category.name = "Oyna";
              snapshot.data!.add(category);
              return GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(5.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: snapshot.data!.map((category) {
                  return GestureDetector(
                    child: Card(
                      elevation: 2,
                      color: category.ID == -1 ? Colors.green : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: AutoSizeText(
                            '${category.name}',
                            style: TextStyle(
                                color: category.ID == -1
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ),
                    ),
                    onTap: () {
                      context.read(questionCategoryState).state = category;
                      if (category.ID != -1) {
                        context.read(isTestMode).state = false;
                        Navigator.pushNamed(context, "/readMode");
                      }
                      else
                        {

                          context.read(isTestMode).state = true;
                          Navigator.pushNamed(context, "/testMode");
                        }
                    },
                  );
                }).toList(),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ));
  }

  Future<List<Category>?> getCategories() async {
    var db = await copyDB();
    var result = await CategoryProvider().getCategories(db);
    //context.read(categoryListProvider).list = result;
    return result;
  }
}
