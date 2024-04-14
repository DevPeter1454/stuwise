import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/loan_details_view.dart';

class DebtsView extends StatefulWidget {
  const DebtsView({super.key});

  @override
  State<DebtsView> createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  final FirebaseFireStoreService _firebaseFireStoreService =
      FirebaseFireStoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // print("${snapshot.data!.docs.first.data()} has data");
                    return snapshot.data!.docs.isEmpty
                        ? const Center(child: Text("No debts added yet"))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final dataList = snapshot.data!.docs;
                              return Padding(
                                padding: EdgeInsets.only(top: 16.v),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                LoanDetailsView(
                                                  loan: Loan(
                                                      currency: dataList[index]
                                                              ["currency"] ??
                                                          '\$',
                                                      principal: dataList[index]
                                                          ["loanPrincipal"],
                                                      interestRate: dataList[
                                                              index]
                                                          ["loanInterestRate"],
                                                      termInMonths: dataList[
                                                              index]
                                                          ["loanTermInMonths"]),
                                                )));
                                  },
                                  child: Container(
                                    height: 170.v,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: AppColors.kWhiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16.v, horizontal: 16.h),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Loan Name: ${dataList[index]['loanName']}",
                                              style: kBodyRegularTextStyle
                                                  .copyWith(
                                                      fontSize: 20.adaptSize)),
                                          verticalSpaceMicroSmall,
                                          Text(
                                            "Principal: ${dataList[index]["loanPrincipal"]}",
                                            style: kSubtitleRegularTextStyle,
                                          ),
                                          verticalSpaceMicroSmall,
                                          Text(
                                            "Loan Interest Rate: ${dataList[index]["loanInterestRate"] * 100}%",
                                            style: kSubtitleRegularTextStyle,
                                          ),
                                          verticalSpaceMicroSmall,
                                          Text(
                                            "Loan Term (years): ${(int.parse(dataList[index]["loanTermInMonths"].toString()) ~/ 12)}",
                                            style: kSubtitleRegularTextStyle,
                                          ),
                                          verticalSpaceMicroSmall,
                                          Text(
                                            "Total Interest Paid: ${double.parse(dataList[index]["totalInterestPaid"].toString()).toStringAsFixed(2)}",
                                            style: kSubtitleRegularTextStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 16.v,
                              );
                            },
                            itemCount: snapshot.data!.docs.length);
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);

                    return const Text("Has Error");
                  }

                  return const SizedBox.shrink();
                })));
  }
}
