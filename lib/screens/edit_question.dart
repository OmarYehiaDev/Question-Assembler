// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:questions_assembler/models/option.dart';
import 'package:questions_assembler/models/question.dart';

class EditQuestion extends StatefulWidget {
  final Question question;
  const EditQuestion({Key? key, required this.question}) : super(key: key);

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  late Question edited;

  final TextEditingController _phraseController = TextEditingController();
  final TextEditingController _optionController = TextEditingController();
  List<Option> options = [];
  bool val = false;

  @override
  void initState() {
    Question _q = widget.question;

    super.initState();
    _phraseController.text = _q.questionPhrase;
    options = _q.options;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Question"),
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
                  controller: _phraseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Choices"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Option result = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                  child: SizedBox(
                                    width: width * 0.9,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: _optionController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width * 0.4,
                                              child: RadioListTile<bool>(
                                                title: Text("True"),
                                                value: true,
                                                groupValue: val,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = value!;
                                                  });
                                                  val = value!;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.4,
                                              child: RadioListTile<bool>(
                                                title: Text("False"),
                                                value: false,
                                                groupValue: val,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = value!;
                                                  });
                                                  val = value!;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Option _option = Option(
                                              answer: _optionController.text,
                                              validity: val,
                                            );
                                            Navigator.pop(context, _option);
                                          },
                                          child: Text("Add"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            setState(() {
                              options.add(result);
                              _optionController.text = "";
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text("Add option"),
                        ),
                      ),
                    ],
                  ),
                  options.isNotEmpty
                      ? Wrap(
                          direction: Axis.horizontal,
                          children: options
                              .map(
                                (e) => Chip(
                                  deleteIcon: Icon(Icons.delete),
                                  onDeleted: () {
                                    setState(() {
                                      options.remove(e);
                                    });
                                  },
                                  backgroundColor:
                                      e.validity ? Colors.green : Colors.red,
                                  avatar: Icon(
                                    e.validity ? Icons.check : Icons.close,
                                  ),
                                  label: Text(e.answer),
                                ),
                              )
                              .toList(),
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            child: Text("Save question"),
            onPressed: () {
              edited = Question(
                questionId: UniqueKey().toString(),
                questionPhrase: _phraseController.text,
                options: options,
              );
              if (edited.questionPhrase.isNotEmpty && options.isNotEmpty) {
                Navigator.pop(context, edited);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
}
