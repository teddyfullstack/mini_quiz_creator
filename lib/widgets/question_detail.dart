import 'package:flutter/material.dart';
import 'package:mini_quiz_creator/state/database.dart';
import 'package:mini_quiz_creator/widgets/rich_content.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/question.dart';

class QuestionDetail extends StatefulWidget {
  QuestionDetail({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  bool showExplanations = false;
  int selectedAnswerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseState>(
      builder: (context, value, child) => Container(
        child: Container(
          child: FocusTraversalGroup(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      launchUrlString(widget.question.src);
                    },
                    child: RichContent(widget.question.question),
                  ),
                  if (widget.question.answers != null)
                    ListAnswer(answers: widget.question.answers!),
                  if (widget.question.subQuestions != null)
                    Column(
                      children: List.generate(
                        widget.question.subQuestions!.length,
                        (index) => Column(
                          children: [
                            RichContent(
                                widget.question.subQuestions![index].question),
                            ListAnswer(
                                answers: widget
                                    .question.subQuestions![index].answers),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListAnswer extends StatefulWidget {
  ListAnswer({super.key, required this.answers});

  final List<String> answers;

  @override
  State<ListAnswer> createState() => _ListAnswerState();
}

class _ListAnswerState extends State<ListAnswer> {
  int selectedAnswerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.answers.length, (int index) {
        return Card(
          color: index == selectedAnswerIndex
              ? Theme.of(context).colorScheme.surfaceVariant
              : null,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            onTap: () {
              setState(() {
                selectedAnswerIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Text(String.fromCharCode(65 + index)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Flexible(child: RichContent(widget.answers[index])),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}