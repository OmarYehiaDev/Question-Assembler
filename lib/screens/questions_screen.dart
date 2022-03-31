// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:questions_assembler/models/question.dart';
import 'package:questions_assembler/screens/edit_question.dart';

class QuestionsScreen extends StatefulWidget {
  final List<Question> list;
  const QuestionsScreen({Key? key, required this.list}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List<Question> _list = [];
  @override
  void initState() {
    _list = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, _list);
          },
        ),
        centerTitle: true,
        title: Text("Questions Screen"),
      ),
      body: _list.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                Question _ques = _list[index];
                return ListTile(
                  title: Text(_ques.questionPhrase),
                  subtitle: Wrap(
                    alignment: WrapAlignment.center,
                    children: _ques.options
                        .map(
                          (op) => Padding(
                            padding: EdgeInsets.all(8),
                            child: Chip(
                              label: Text(
                                op.answer,
                              ),
                              avatar: Icon(
                                op.validity ? Icons.check : Icons.close,
                              ),
                              backgroundColor:
                                  op.validity ? Colors.green : Colors.red,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  onLongPress: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Remove question"),
                          content: Text(
                            "Are you sure about removing this question?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                _list.remove(_ques);
                                if (!mounted) return;
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onTap: () async {
                    final Question result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditQuestion(
                          question: _ques,
                        ),
                      ),
                    );
                    setState(() {
                      _list[index] = result;
                    });
                  },
                );
              },
              itemCount: _list.length,
            )
          : Center(
              child: Text("There's no questions yet :'("),
            ),
    );
  }
}
