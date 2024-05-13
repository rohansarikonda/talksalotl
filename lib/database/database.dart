// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import '../constants.dart';
import '../keys.dart';

class MongoDatabase {
  static var db;
  static var questionCollection;

  static connect() async {
    try {
      db = await Db.create(mongoConnectString);
      await db!.open();
      questionCollection = db.collection(AppConstants.questionsCollection);
    } catch (e) {
      log(e.toString());
    }

    // db = await Db.create(mongoConnectString);
    // await db.open();
    // questionCollection = db.collection(AppConstants.questionsCollection);
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final questions = await questionCollection.find().toList();
      return questions;
    } catch (e) {
      log(e.toString());
      return Future.value(e as FutureOr<List<Map<String, dynamic>>>?);
    }
  }
}
