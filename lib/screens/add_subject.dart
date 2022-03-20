// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:questions_assembler/models/question.dart';
import 'package:questions_assembler/models/subject.dart';
import 'package:questions_assembler/screens/add_question.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  late Subject subject;
  final TextEditingController _nameController = TextEditingController();
  List<Question> easyQs = [];
  List<Question> mediumQs = [];
  List<Question> hardQs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add subject"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.question_mark),
                title: Text("Easy Questions"),
                trailing: ElevatedButton.icon(
                  onPressed: () async {
                    final Question result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddQuestion(),
                      ),
                    );
                    setState(() {
                      easyQs.add(result);
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Questions"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.question_mark),
                title: Text("Medium Questions"),
                trailing: ElevatedButton.icon(
                  onPressed: () async {
                    final Question result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddQuestion(),
                      ),
                    );
                    setState(() {
                      mediumQs.add(result);
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Questions"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.question_mark),
                title: Text("Hard Questions"),
                trailing: ElevatedButton.icon(
                  onPressed: () async {
                    final Question result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddQuestion(),
                      ),
                    );
                    setState(() {
                      hardQs.add(result);
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Questions"),
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            child: Text("Save subject"),
            onPressed: () {
              subject = Subject(
                name: _nameController.text,
                easy: easyQs,
                medium: mediumQs,
                hard: hardQs,
              );
              Navigator.pop(context, subject);
            },
          ),
        ),
      ],
    );
  }
}
