// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:questions_assembler/models/option.dart';
import 'package:questions_assembler/models/question.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  late Question question;
  final TextEditingController _phraseController = TextEditingController();
  final TextEditingController _optionController = TextEditingController();
  List<Option> options = [];
  @override
  Widget build(BuildContext context) {
    bool val = false;

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add question"),
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
              question = Question(
                questionId: UniqueKey().toString(),
                questionPhrase: _phraseController.text,
                options: options,
              );
              Navigator.pop(context, question);
            },
          ),
        ),
      ],
    );
  }
}
