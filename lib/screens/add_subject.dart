// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:questions_assembler/models/question.dart';
import 'package:questions_assembler/models/subject.dart';
import 'package:questions_assembler/screens/add_question.dart';
import 'package:questions_assembler/utils/constants.dart';
import 'package:questions_assembler/utils/theme.dart';

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
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text(
          "Add Subject",
          style: AppTextStyles.appBarTitle.copyWith(
            fontSize: 20,
          ),
        ),
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
                    hintText: "Subject Name",
                    hintStyle: AppTextStyles.body,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: AppColors.primary,
                  leading: Icon(
                    Icons.question_mark,
                    color: AppColors.secondary,
                  ),
                  title: Text(
                    "Easy Questions",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppColors.secondary),
                      foregroundColor: MaterialStatePropertyAll(AppColors.primary),
                    ),
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
                    label: Text(
                      "Add Questions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: AppColors.primary,
                  leading: Icon(
                    Icons.question_mark,
                    color: AppColors.secondary,
                  ),
                  title: Text(
                    "Medium Questions",
                    textAlign: TextAlign.justify,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppColors.secondary),
                      foregroundColor: MaterialStatePropertyAll(AppColors.primary),
                    ),
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
                    label: Text(
                      "Add Questions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: AppColors.primary,
                  leading: Icon(
                    Icons.question_mark,
                    color: AppColors.secondary,
                  ),
                  title: Text(
                    "Hard Questions",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppColors.secondary),
                      foregroundColor: MaterialStatePropertyAll(AppColors.primary),
                    ),
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
                    label: Text(
                      "Add Questions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppColors.secondary),
              foregroundColor: MaterialStatePropertyAll(AppColors.primary),
            ),
            child: Text(
              "Save Subject",
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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
