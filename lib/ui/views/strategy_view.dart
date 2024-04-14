import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/core/models/loan_result.dart';
import 'package:stuwise/core/models/payment_model.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/avalanche_view.dart';
import 'package:stuwise/ui/views/loan_details_view.dart';
import 'package:stuwise/ui/views/snowball_view.dart';
import 'package:stuwise/ui/widgets/custom_text_button.dart';
import 'package:toastification/toastification.dart';

enum RepaymentStrategy { unselected, avalanche, snowBall }

class StrategyView extends StatefulWidget {
  const StrategyView({super.key});

  @override
  State<StrategyView> createState() => _StrategyViewState();
}

class _StrategyViewState extends State<StrategyView> {
  RepaymentStrategy checkboxValue = RepaymentStrategy.unselected;
  final FirebaseFireStoreService _firebaseFireStoreService =
      FirebaseFireStoreService();
  ScrollController controller = ScrollController();

  List<LoanResult>? calculateRepaymentSchedule(
      List<Loan> loans, RepaymentStrategy strategy) {
    List<LoanResult> loanResults = [];

    for (Loan loan in loans) {
      LoanResult result = loan.generateAmortizationSchedule();
      loanResults.add(result);
    }

    switch (strategy) {
      case RepaymentStrategy.avalanche:
        loanResults
            .sort((a, b) => b.loan.interestRate.compareTo(a.loan.interestRate));
        return loanResults;

      case RepaymentStrategy.snowBall:
        loanResults
            .sort((a, b) => a.loan.principal.compareTo(b.loan.principal));
        return loanResults;

      default:
        return null;
    }
  }

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
            child: StreamBuilder(
                stream: _firebaseFireStoreService.getUserLoanList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? const Center(child: Text("No debts added yet"))
                        : Padding(
                            padding: kEdgeInsetsAllNormal,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        controller: controller,
                                        itemBuilder: (context, index) {
                                          final dataList = snapshot.data!.docs;
                                          return Padding(
                                            padding: EdgeInsets.only(top: 16.v),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder:
                                                            (context) =>
                                                                LoanDetailsView(
                                                                  loan: Loan(
                                                                      currency:
                                                                          dataList[index]
                                                                              [
                                                                              "currency"],
                                                                      principal:
                                                                          dataList[index]
                                                                              [
                                                                              "loanPrincipal"],
                                                                      interestRate:
                                                                          dataList[index]
                                                                              [
                                                                              "loanInterestRate"],
                                                                      termInMonths:
                                                                          dataList[index]
                                                                              [
                                                                              "loanTermInMonths"]),
                                                                )));
                                              },
                                              child: ListTile(
                                                contentPadding:
                                                    kEdgeInsetsHorizontalTiny,
                                                leading: Container(
                                                  height: 50.v,
                                                  width: 50.h,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                titleAlignment:
                                                    ListTileTitleAlignment
                                                        .center,
                                                title: Text(
                                                    "Loan Name: ${dataList[index]['loanName']}",
                                                    style: kBodyRegularTextStyle
                                                        .copyWith(
                                                            fontSize:
                                                                18.adaptSize)),
                                                subtitle: Text(
                                                  "Total Interest Paid: ${double.parse(dataList[index]["totalInterestPaid"].toString()).toStringAsFixed(2)}",
                                                  style:
                                                      kSubtitleRegularSmallTextStyle,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 10.v,
                                          );
                                        },
                                        itemCount: snapshot.data!.docs.length),
                                  ),
                                  verticalSpaceMini,
                                  Text("Choose Repayment Strategy",
                                      style: kSubtitleTextStyle.copyWith(
                                          color: AppColors.kTextDefaultColor)),
                                  Row(
                                    children: [
                                      Checkbox(
                                          tristate: true,
                                          value: checkboxValue ==
                                              RepaymentStrategy.avalanche,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == null) {
                                                checkboxValue =
                                                    RepaymentStrategy
                                                        .unselected;
                                              } else {
                                                checkboxValue = value
                                                    ? RepaymentStrategy
                                                        .avalanche
                                                    : RepaymentStrategy
                                                        .snowBall;
                                              }
                                            });
                                          }),
                                      Text("Avalanche Strategy",
                                          style: kBodyRegularTextStyle.copyWith(
                                              color:
                                                  AppColors.kTextDefaultColor))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          tristate: true,
                                          value: checkboxValue ==
                                              RepaymentStrategy.snowBall,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == null) {
                                                checkboxValue =
                                                    RepaymentStrategy
                                                        .unselected;
                                              } else {
                                                checkboxValue = value
                                                    ? RepaymentStrategy.snowBall
                                                    : RepaymentStrategy
                                                        .avalanche;
                                              }
                                            });
                                          }),
                                      Text("SnowBall Strategy",
                                          style: kBodyRegularTextStyle.copyWith(
                                              color:
                                                  AppColors.kTextDefaultColor))
                                    ],
                                  ),
                                  verticalSpaceMicro,
                                  Center(
                                    child: CustomButton(
                                        onPressed: () {
                                          if (checkboxValue ==
                                              RepaymentStrategy.snowBall) {
                                            var result = calculateRepaymentSchedule(
                                                snapshot.data!.docs
                                                    .map((e) => Loan(
                                                        currency: e["currency"],
                                                        principal:
                                                            e["loanPrincipal"],
                                                        interestRate: e[
                                                            "loanInterestRate"],
                                                        termInMonths: e[
                                                            "loanTermInMonths"]))
                                                    .toList(),
                                                RepaymentStrategy.snowBall);

                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SnowBallView(
                                                          loanResult: result!,
                                                        )));
                                          } else if (checkboxValue ==
                                              RepaymentStrategy.avalanche) {
                                            var result = calculateRepaymentSchedule(
                                                snapshot.data!.docs
                                                    .map((e) => Loan(
                                                        currency: e["currency"],
                                                        principal:
                                                            e["loanPrincipal"],
                                                        interestRate: e[
                                                            "loanInterestRate"],
                                                        termInMonths: e[
                                                            "loanTermInMonths"]))
                                                    .toList(),
                                                RepaymentStrategy.avalanche);
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        AvalancheView(
                                                          loanResult: result!,
                                                        )));
                                          } else {
                                            toastification.show(
                                                context: context,
                                                icon: const Icon(Icons.error),
                                                style: ToastificationStyle
                                                    .flatColored,
                                                autoCloseDuration:
                                                    const Duration(seconds: 3),
                                                title: const Text(
                                                    "Please select a repayment strategy"),
                                                type: ToastificationType.error);
                                          }
                                        },
                                        size: Size(
                                            MediaQuery.of(context).size.width,
                                            60),
                                        backgroundColor:
                                            AppColors.kPrimaryColor,
                                        text: "View Result",
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        style:
                                            kSubtitleRegularTextStyle.copyWith(
                                                color: AppColors.kWhiteColor)),
                                  )
                                ],
                              ),
                            ),
                          );
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);

                    return const Text("Has Error");
                  }

                  return const SizedBox.shrink();
                })));
  }
}
