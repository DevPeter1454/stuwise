import 'package:flutter/material.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/ui/constants/exports.dart';

class LoanDetailsView extends StatefulWidget {
  final Loan loan;
  const LoanDetailsView({super.key, required this.loan, });

  @override
  State<LoanDetailsView> createState() => _LoanDetailsViewState();
}

class _LoanDetailsViewState extends State<LoanDetailsView> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Loan Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DataTable(
                  // columnSpacing: 10,
                  columns: [
                    DataColumn(
                        label: Text(
                      'Month',
                      style: kBodyRegularTextStyle,
                    )),
                    DataColumn(
                        label: Text(
                      'Principal\nPayment',
                      style: kSmallRegularTextStyle,
                    )),
                    DataColumn(
                        label: Text(
                      'Interest\nPayment',
                      style: kBodyRegularTextStyle,
                    )),
                    DataColumn(
                        label: Text(
                      'Balance',
                      style: kBodyRegularTextStyle,
                    )),
                  ],
                  rows: loanPaymentList.map((payment) {
                    return DataRow(
                      cells: [
                        DataCell(Text(payment.month.toString())),
                        DataCell(Text(
                            '${widget.loan.currency}${payment.principalPayment.toStringAsFixed(2)}')),
                        DataCell(Text(
                            '${widget.loan.currency}${payment.interestPayment.toStringAsFixed(2)}')),
                        DataCell(Text(
                            '${widget.loan.currency}${payment.remainingBalance.toStringAsFixed(2)}')),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ))
        // ListView.separated(
        //     shrinkWrap: true,
        //     itemBuilder: (context, index) {
        //       final loanPaymentList =
        //           widget.loan.generateAmortizationSchedule().schedule;
        //       return Container(
        //           height: 170.v,
        //           width: double.maxFinite,
        //           decoration: BoxDecoration(
        //             color: AppColors.kWhiteColor,
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //           child: Padding(
        //             padding:
        //                 EdgeInsets.symmetric(vertical: 16.v, horizontal: 16.h),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   "Month ${loanPaymentList[index].month}",
        //                   style: kBodyRegularTextStyle.copyWith(
        //                       fontSize: 20.adaptSize),
        //                 ),
        //                 verticalSpaceMicro,
        //                 Text(
        //                   "Principal Payment: £${loanPaymentList[index].principalPayment.toStringAsFixed(2)}",
        //                   style: kSubtitleRegularTextStyle,
        //                 ),
        //                 verticalSpaceMicro,
        //                 Text(
        //                   "Interest Payment: £${loanPaymentList[index].interestPayment.toStringAsFixed(2)}",
        //                   style: kSubtitleRegularTextStyle,
        //                 ),
        //                 verticalSpaceMicro,
        //                 Text(
        //                   "Remaining Balance: £${loanPaymentList[index].remainingBalance.toStringAsFixed(2)}",
        //                   style: kSubtitleRegularTextStyle,
        //                 ),
        //               ],
        //             ),
        //           ));
        //     },
        //     separatorBuilder: (context, index) {
        //       return SizedBox(
        //         height: 16.v,
        //       );
        //     },
        //     itemCount:
        //         widget.loan.generateAmortizationSchedule().schedule.length),
        );
  }
}
