// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:questions_assembler/models/subject.dart';

class TestBankStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/db.txt');
  }

  Future<List<Subject>> readBank() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      return decodeSubjectsFromJson(contents);
    } catch (e) {
      // If encountering an error, return empty list
      return [];
    }
  }

  Future<File> writeBank(String data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(data);
  }
}
