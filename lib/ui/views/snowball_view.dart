// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/core/models/loan_class.dart';

import 'package:stuwise/core/models/loan_result.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/loan_details_view.dart';

class SnowBallView extends StatefulWidget {
  final List<LoanResult> loanResult;

  const SnowBallView({
    super.key,
    required this.loanResult,
    
  });

  @override
  State<SnowBallView> createState() => _SnowBallViewState();
}

class _SnowBallViewState extends State<SnowBallView> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repayment Strategy",
            style: kSubtitleTextStyle.copyWith(
                color: AppColors.kTextDefaultColor)),
        centerTitle: true,
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/background.png",
            ),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
              padding: kEdgeInsetsAllNormal,
              controller: controller,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Snowball Strategy",
                        style: kHeading2TextStyle.copyWith(
                            color: AppColors.kTextDefaultColor)),
                    verticalSpaceMicroSmall,
                    Text(
                      "Target the loan with the smallest balance first, providing a sense of accomplishment and potentially motivating you to stay on track as you see loans disappear from the list",
                      style: kSubtitleRegularSmallTextStyle,
                    ),
                    verticalSpaceMicroSmall,
                    ListView.separated(
                        shrinkWrap: true,
                        controller: controller,
                        itemCount: widget.loanResult.length,
                        separatorBuilder: (context, index) {
                          return verticalSpaceMicroSmall;
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => LoanDetailsView(
                                          loan: Loan(
                                              currency: widget
                                                    .loanResult[index].loan.currency ,
                                              principal: widget
                                                  .loanResult[index]
                                                  .loan
                                                  .principal,
                                              interestRate: widget
                                                  .loanResult[index]
                                                  .loan
                                                  .interestRate,
                                              termInMonths: widget
                                                  .loanResult[index]
                                                  .loan
                                                  .termInMonths),)));
                            },
                            child: Container(
                              height: 150.v,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: AppColors.kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.v, horizontal: 16.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Principal: ${widget.loanResult[index].loan.principal}",
                                      style: kSubtitleRegularTextStyle,
                                    ),
                                    verticalSpaceMicroSmall,
                                    Text(
                                      "Loan Interest Rate: ${widget.loanResult[index].loan.interestRate * 100}%",
                                      style: kSubtitleRegularTextStyle,
                                    ),
                                    verticalSpaceMicroSmall,
                                    Text(
                                      "Loan Term (years): ${(int.parse(widget.loanResult[index].loan.termInMonths.toString()) ~/ 12)}",
                                      style: kSubtitleRegularTextStyle,
                                    ),
                                    verticalSpaceMicroSmall,
                                    Text(
                                      "Total Interest Paid: ${double.parse(widget.loanResult[index].totalInterestPaid.toString()).toStringAsFixed(2)}",
                                      style: kSubtitleRegularTextStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ]))),
    );
  }
}
