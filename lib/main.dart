// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_new, import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:questions_assembler/models/question.dart';
// import 'package:questions_assembler/helpers/theme.dart';
import 'package:questions_assembler/models/subject.dart';
import 'package:questions_assembler/screens/add_subject.dart';
import 'package:questions_assembler/screens/edit_subject.dart';
import 'package:questions_assembler/services/middleware.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

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
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Assembler"),
      ),
      body: Center(
        child: _subjects.isNotEmpty
            ? ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  Subject _subject = _subjects[index];
                  List<Question> _qs =
                      (_subject.easy + _subject.medium + _subject.hard);
                  return ListTile(
                    title: Text(_subject.name),
                    trailing: Text(
                      "Number of questions: ${_qs.length}",
                    ),
                    onLongPress: () async {
                      //* Function to make PDF file
                      // TODO: Needs to be moved to `make_test.dart`
                      final pdf = pw.Document();
                      var arabicFont = pw.Font.ttf(
                        await rootBundle.load(
                          "assets/fonts/HacenTunisia.ttf",
                        ),
                      );
                      pdf.addPage(
                        pw.MultiPage(
                          textDirection: pw.TextDirection.rtl,
                          theme: pw.ThemeData.withFont(
                            base: arabicFont,
                          ),
                          pageFormat: PdfPageFormat.a4,
                          build: (pw.Context context) {
                            List<Question> _specificRand = List.generate(
                              5,
                              (index) => randomChoice<Question>(_qs),
                            );
                            return [
                              pw.Align(
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.all(12.0),
                                  child: pw.Text(
                                    _subject.name,
                                    style: pw.TextStyle(
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                alignment: pw.Alignment.center,
                              ),
                              pw.ListView.separated(
                                itemBuilder: (context, index) {
                                  Question _q = _specificRand[index];
                                  return pw.Container(
                                    width: width,
                                    height: height * 0.07,
                                    child: pw.Column(
                                      children: [
                                        pw.Align(
                                          child: pw.Padding(
                                            child: pw.Text(
                                              " - ${index + 1} " +
                                                  _q.questionPhrase,
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            padding: pw.EdgeInsets.all(5.0),
                                          ),
                                          alignment: pw.Alignment.centerRight,
                                        ),
                                        pw.Row(
                                          mainAxisSize: pw.MainAxisSize.max,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceEvenly,
                                          children: _q.options
                                              .map(
                                                (e) => pw.Row(
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment.start,
                                                  children: [
                                                    pw.Padding(
                                                      padding: pw.EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      child: pw.Text(
                                                        e.answer,
                                                        style: pw.TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          pw.BoxDecoration(
                                                        border: pw.Border.all(
                                                          color:
                                                              PdfColors.black,
                                                        ),
                                                        shape:
                                                            pw.BoxShape.circle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    pw.Divider(height: height * 0.015),
                                itemCount: _specificRand.length,
                              ),
                            ];
                          },
                        ),
                      );
                      final output = await getApplicationDocumentsDirectory();
                      final file = File("${output.path}/example.pdf");
                      await file.writeAsBytes(
                        await pdf.save(),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(),
                            body: PdfPreview(
                              build: (format) => pdf.save(),
                            ),
                          ),
                        ),
                      );
                    },
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
                      await _storage.writeBank(
                        encodeSubjects(_subjects),
                      );
                    },
                  );
                },
              )
            : Text("There's no subjects yet :'("),
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
          await _storage.writeBank(
            encodeSubjects(_subjects),
          );
        },
        tooltip: 'Add subject',
        child: const Icon(Icons.add),
      ),
    );
  }
}
