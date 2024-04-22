import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/ui/constants/exports.dart';

class LoanDetailsView extends StatefulWidget {
  final Loan loan;
  const LoanDetailsView({
    super.key,
    required this.loan,
  });

  @override
  State<LoanDetailsView> createState() => _LoanDetailsViewState();
}

class _LoanDetailsViewState extends State<LoanDetailsView> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final loanPaymentList = widget.loan.generateAmortizationSchedule().schedule;
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: Text(
            'Loan Repayment Schedule',
            style: kHeading2TextStyle,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
            padding: kEdgeInsetsAllNormal,
            controller: controller,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Loan Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (context, index) {
                    final loanPaymentList =
                        widget.loan.generateAmortizationSchedule().schedule;
                    return Container(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Month ${loanPaymentList[index].month}",
                                style: kBodyRegularTextStyle.copyWith(
                                    fontSize: 20.adaptSize),
                              ),
                              verticalSpaceMicro,
                              Text(
                                "Principal Payment: £${loanPaymentList[index].principalPayment.toStringAsFixed(2)}",
                                style: kSubtitleRegularTextStyle,
                              ),
                              verticalSpaceMicro,
                              Text(
                                "Interest Payment: £${loanPaymentList[index].interestPayment.toStringAsFixed(2)}",
                                style: kSubtitleRegularTextStyle,
                              ),
                              verticalSpaceMicro,
                              Text(
                                "Remaining Balance: £${loanPaymentList[index].remainingBalance.toStringAsFixed(2)}",
                                style: kSubtitleRegularTextStyle,
                              ),
                            ],
                          ),
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.v,
                    );
                  },
                  itemCount: widget.loan
                      .generateAmortizationSchedule()
                      .schedule
                      .length),
            ])));
  }
}
