// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_new, import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:questions_assembler/models/question.dart';
// import 'package:questions_assembler/helpers/theme.dart';
import 'package:questions_assembler/models/subject.dart';
import 'package:questions_assembler/screens/make_test.dart';
import 'package:questions_assembler/services/middleware.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:questions_assembler/utils/constants.dart';

import 'screens/add_subject.dart';
import 'screens/edit_subject.dart';
import 'utils/theme.dart';

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
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          brightness: Brightness.dark,
        ),
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
  List<Subject> subjects = [];

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        title: Text(
          "Quizzy",
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateTest(),
                ),
              );
            },
            icon: Icon(Icons.text_snippet),
          ),
        ],
      ),
      body: Center(
        child: subjects.isNotEmpty
            ? ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  Subject subject = subjects[index];
                  List<Question> qs = (subject.easy + subject.medium + subject.hard);
                  return ListTile(
                    title: Text(subject.name),
                    trailing: Text(
                      "Number of questions: ${qs.length}",
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
                            List<Question> specificRand = List.generate(
                              5,
                              (index) => randomChoice<Question>(qs),
                            );
                            return [
                              pw.Align(
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.all(12.0),
                                  child: pw.Text(
                                    subject.name,
                                    style: pw.TextStyle(
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                alignment: pw.Alignment.center,
                              ),
                              pw.ListView.separated(
                                itemBuilder: (context, index) {
                                  Question q = specificRand[index];
                                  return pw.Container(
                                    width: width,
                                    height: height * 0.07,
                                    child: pw.Column(
                                      children: [
                                        pw.Align(
                                          child: pw.Padding(
                                            child: pw.Text(
                                              " - ${index + 1} ${q.questionPhrase}",
                                              textDirection: pw.TextDirection.rtl,
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
                                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                          children: q.options
                                              .map(
                                                (e) => pw.Row(
                                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                                  children: [
                                                    pw.Padding(
                                                      padding: pw.EdgeInsets.symmetric(
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
                                                      decoration: pw.BoxDecoration(
                                                        border: pw.Border.all(
                                                          color: PdfColors.black,
                                                        ),
                                                        shape: pw.BoxShape.circle,
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
                                itemCount: specificRand.length,
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
                      if (!mounted) return;
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
                          builder: (_) => EditSubject(subject: subject),
                        ),
                      );
                      setState(() {
                        subjects[index] = result;
                      });
                      await _storage.writeBank(
                        encodeSubjects(subjects),
                      );
                    },
                  );
                },
              )
            : Text(
                "There's no subjects yet :'(",
                style: AppTextStyles.body.copyWith(
                  fontFamily: Constants.secondaryFontFamily,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Add Subject",
          style: AppTextStyles.body,
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        onPressed: () async {
          final Subject? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSubject(),
            ),
          );
          setState(() {
            if (result != null) subjects.add(result);
          });
          await _storage.writeBank(
            encodeSubjects(subjects),
          );
        },
        tooltip: 'Add subject',
        icon: const Icon(Icons.add),
      ),
    );
  }
}
