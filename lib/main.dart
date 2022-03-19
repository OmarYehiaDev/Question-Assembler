// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:questions_assembler/helpers/theme.dart';
import 'package:questions_assembler/models/subject.dart';
import 'package:questions_assembler/screens/add_subject.dart';
import 'package:questions_assembler/screens/edit_subject.dart';
import 'package:questions_assembler/services/middleware.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Question Assembler',
      theme: ThemeData(
        primaryColor: ThemeColors.primaryColor,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TestBankStorage _storage = TestBankStorage();
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _storage.readBank().then((value) {
      if (!mounted) return;
      setState(() {
        _subjects = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Assembler"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _subjects.length,
          itemBuilder: (context, index) {
            if (_subjects.isNotEmpty) {
              Subject _subject = _subjects[index];
              return ListTile(
                title: Text(_subject.name),
                trailing: Text(
                  "Number of questions: ${_subject.easy.length + _subject.medium.length + _subject.hard.length}",
                ),
                onTap: () async {
                  final Subject result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditSubject(subject: _subject),
                    ),
                  );
                  setState(() {
                    _subjects[index] = result;
                  });
                },
              );
            }
            return Text("There's no subjects yet :'(");
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Subject result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSubject(),
            ),
          );
          setState(() {
            _subjects.add(result);
          });
          _storage.writeBank(
            encodeSubjects(_subjects),
          );
        },
        tooltip: 'Add subject',
        child: const Icon(Icons.add),
      ),
    );
  }
}
