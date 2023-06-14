// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

import '../models/question.dart';
import '../models/subject.dart';
import '../services/middleware.dart';

class GenerateTest extends StatefulWidget {
  const GenerateTest({Key? key}) : super(key: key);

  @override
  State<GenerateTest> createState() => _GenerateTestState();
}

class _GenerateTestState extends State<GenerateTest> {
  final TestBankStorage _storage = TestBankStorage();
  List<Subject> subjects = [];
  Subject? chosen;
  int testQsCount = 10;
  @override
  void initState() {
    super.initState();
    _storage.readBank().then((value) {
      if (!mounted) return;
      setState(() {
        subjects = value;
      });
    });
  }

  Widget _chooseSubject() {
    return subjects.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              Subject subject = subjects[index];
              List<Question> qs =
                  (subject.easy + subject.medium + subject.hard);
              return ListTile(
                title: Text(subject.name),
                trailing: Text(
                  "Number of questions: ${qs.length}",
                ),
                onTap: () {
                  setState(() {
                    chosen = subject;
                  });
                },
              );
            },
          )
        : Text("There's no subjects yet :'(");
  }

  Widget _randomizeQs() {
    return chosen == null ? Text(" This is unavailable") : Text(chosen!.name);
  }

  int activeStep = 0;
  int dotCount = 3;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _chooseSubject(),
      _randomizeQs(),
      Text("Generate Test"),
    ];

    /// Returns the next button widget.
    Widget nextButton() {
      return ElevatedButton(
        onPressed: activeStep != 2
            ? () {
                if (activeStep < dotCount - 1) {
                  setState(() {
                    activeStep++;
                  });
                  if (activeStep == 1 && chosen == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "You cannot view it now. choose subject first",),
                      ),
                    );
                  }
                }
              }
            : null,
        child: Text('Next'),
      );
    }

    /// Returns the previous button widget.
    Widget previousButton() {
      return ElevatedButton(
        onPressed: activeStep == 0
            ? null
            : () {
                if (activeStep > 0) {
                  setState(() {
                    activeStep--;
                  });
                }
              },
        child: Text('Prev'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Make Test"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                previousButton(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DotStepper(
                    dotRadius: 6,
                    activeStep: activeStep,
                    dotCount: dotCount,
                    spacing: 14,
                    indicator: Indicator.worm,
                    tappingEnabled: false,
                    indicatorDecoration: IndicatorDecoration(
                      color: Colors.red,
                    ),
                  ),
                ),
                nextButton(),
              ],
            ),
            pages[activeStep]
          ],
        ),
      ),
    );
  }
}
