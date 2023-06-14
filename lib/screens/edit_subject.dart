// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:questions_assembler/models/question.dart';
import 'package:questions_assembler/models/subject.dart';
import 'package:questions_assembler/screens/add_question.dart';
import 'package:questions_assembler/screens/questions_screen.dart';

class EditSubject extends StatefulWidget {
  final Subject subject;
  const EditSubject({Key? key, required this.subject}) : super(key: key);

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  late Subject edited;
  final TextEditingController _nameController = TextEditingController();
  List<Question> easyQs = [];
  List<Question> mediumQs = [];
  List<Question> hardQs = [];

  @override
  void initState() {
    Subject old = widget.subject;
    super.initState();
    _nameController.text = old.name;
    easyQs = old.easy;
    mediumQs = old.medium;
    hardQs = old.hard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit subject"),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                subtitle: Text("Number of questions: ${easyQs.length}"),
                onTap: () async {
                  final List<Question> data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionsScreen(
                        list: easyQs,
                      ),
                    ),
                  );
                  setState(() {
                    easyQs = data;
                  });
                },
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
                subtitle: Text("Number of questions: ${mediumQs.length}"),
                onTap: () async {
                  final List<Question> data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionsScreen(
                        list: mediumQs,
                      ),
                    ),
                  );
                  setState(() {
                    mediumQs = data;
                  });
                },
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
                subtitle: Text("Number of questions: ${hardQs.length}"),
                onTap: () async {
                  final List<Question> data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionsScreen(
                        list: hardQs,
                      ),
                    ),
                  );
                  setState(() {
                    hardQs = data;
                  });
                },
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
              edited = Subject(
                name: _nameController.text,
                easy: easyQs,
                medium: mediumQs,
                hard: hardQs,
              );
              Navigator.pop(context, edited);
            },
          ),
        ),
      ],
    );
  }
}
