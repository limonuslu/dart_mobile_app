

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:a/const/const.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> copyDB() async{
  var dbPath = await getDatabasesPath();
  var path = join(dbPath, db_name);

  var exists = await databaseExists(path);
  if(!exists)
    {
      try{
        await Directory(dirname(path)).create(recursive: true);
      }catch(_){}

      ByteData data = await rootBundle.load(join("assets/db", db_name));
      List<int> byte = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(byte, flush:true);

    }else
      {
        print('Veritabanı Zaten Mevcut');
      }
  return await openDatabase(path, readOnly: true);

}