// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/loan_details_view.dart';
import 'package:stuwise/ui/widgets/custom_dropdown.dart';
import 'package:stuwise/ui/widgets/custom_text_button.dart';
import 'package:stuwise/ui/widgets/custom_text_field.dart';
import 'package:toastification/toastification.dart';

class LoanCalcView extends StatefulWidget {
  const LoanCalcView({super.key});

  @override
  State<LoanCalcView> createState() => _LoanCalcViewState();
}

class _LoanCalcViewState extends State<LoanCalcView> {
  final TextEditingController _amountTEC = TextEditingController();
  final TextEditingController _rateTEC = TextEditingController();
  final TextEditingController _termTEC = TextEditingController();
  final TextEditingController _nameTEC = TextEditingController();

  final FirebaseFireStoreService _firebaseFireStoreService =
      FirebaseFireStoreService();

  bool isLoading = false;
  bool isValidationPassed = false;

  String? _selectedValue;

  final List<String> _dropdownItems = [];

  List<String> get dropdownItems => _dropdownItems;

  String? get selectedValue => _selectedValue;

  void setSelectedValue(String value) {
    setState(() {
      _selectedValue = value;
    });
  }

  Future<void> saveLoanToFireStore(Loan loan) async {
    setState(() {
      isLoading = true;
    });

    final result = await _firebaseFireStoreService.saveNewLoan(
        loan, context, _nameTEC.text);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => LoanDetailsView(
                    loan: loan,
                  )));
    }
  }

  void validatorFunction() {
    if (_amountTEC.text.isEmpty ||
        _rateTEC.text.isEmpty ||
        _termTEC.text.isEmpty ||
        _nameTEC.text.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: const Text("Please fill all form fields"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else {
      setState(() {
        isValidationPassed = true;
      });
    }
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/world_currency_symbols.json');
    final data = await json.decode(response) as List;
    for (var element in data) {
      _dropdownItems.add(
          ' ${element['CountryName']} ${element['Currency']} ${element['Symbol']}');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loan Details',
          style: kHeading2TextStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 16.h),
        child: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/background.png",
            ),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            child: Visibility(
              visible: !isLoading,
              replacement: const Center(child: CircularProgressIndicator()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceMicro,
                  Text("Currency", style: kSubtitleRegularTextStyle),
                  verticalSpaceMicroSmall,
                  CustomDropdown(
                    dropdownItems: dropdownItems,
                    onChanged: (value) => setSelectedValue(value),
                    hintText: 'Currency',
                  ),
                  verticalSpaceMini,
                  Text("Loan Name", style: kSubtitleRegularTextStyle),
                  verticalSpaceMicroSmall,
                  CustomTextField(
                    textInputType: TextInputType.text,
                    hintText: "e.g House loan",
                    inputController: _nameTEC,
                  ),
                  verticalSpaceMini,
                  Text("Loan Amount", style: kSubtitleRegularTextStyle),
                  verticalSpaceMicroSmall,
                  CustomTextField(
                    textInputType: TextInputType.number,
                    hintText: "0.0",
                    inputController: _amountTEC,
                  ),
                  verticalSpaceMini,
                  Text("Interest Rate", style: kSubtitleRegularTextStyle),
                  verticalSpaceMicroSmall,
                  CustomTextField(
                    hintText: "0.0",
                    textInputType: TextInputType.number,
                    inputController: _rateTEC,
                  ),
                  verticalSpaceMini,
                  Text("Term (years)", style: kSubtitleRegularTextStyle),
                  verticalSpaceMicroSmall,
                  CustomTextField(
                    hintText: "5",
                    textInputType: TextInputType.number,
                    inputController: _termTEC,
                  ),
                  verticalSpaceMini,
                  Center(
                    child: CustomButton(
                        onPressed: () async {
                          validatorFunction();
                          
                          if (isValidationPassed) {
                            Loan loan = Loan(
                                currency:
                                    selectedValue.toString().split(" ").last,
                                principal: double.parse(_amountTEC.text),
                                interestRate: double.parse(_rateTEC.text) / 100,
                                termInMonths: int.parse(_termTEC.text) * 12);
                            await saveLoanToFireStore(loan);
                          }
                        },
                        size: Size(MediaQuery.of(context).size.width, 60),
                        backgroundColor: AppColors.kPrimaryColor,
                        text: "Calculate",
                        borderRadius: BorderRadius.circular(100),
                        style: kSubtitleRegularTextStyle.copyWith(
                            color: AppColors.kWhiteColor)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
