import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/chat_view.dart';

class LearnView extends StatefulWidget {
  const LearnView({super.key});

  @override
  State<LearnView> createState() => _LearnViewState();
}

class _LearnViewState extends State<LearnView> {
  final List<String> _topicsList = [
    "Tips to increase your credit score",
    "Difference between good and bad credit",
    "Effective Debt Management",
    "Budgeting Basics",
    "Risks of Defaulting on Loans",
    "Loan Repayment Strategies",
    "Importance of Credit Scores",
    "Understanding Loan Amortization",
  ];

  List<String> get topicsList => _topicsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Learning Resources",
              style: kSubtitleTextStyle.copyWith(
                  color: AppColors.kTextDefaultColor)),
          centerTitle: true,
        ),
        body: Container(
          height: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/background.png",
            ),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ChatView(prompt: topicsList[index]),
                                ));
                          },
                          child: LearnTileWidget(title: topicsList[index]));
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16.v);
                    },
                    itemCount: topicsList.length)),
          ),
        ));
  }
}

class LearnTileWidget extends StatelessWidget {
  final String title;
  const LearnTileWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: kEdgeInsetsHorizontalTiny,
      leading: Container(
        height: 50.v,
        width: 50.h,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: const Icon(
          Icons.lightbulb,
          color: Colors.white,
        ),
      ),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(title,
          style: kBodyRegularTextStyle.copyWith(fontSize: 14.adaptSize)),
    );
  }
}
