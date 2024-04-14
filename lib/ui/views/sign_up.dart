// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/sign_in.dart';
import 'package:stuwise/ui/widgets/custom_text_button.dart';
import 'package:stuwise/ui/widgets/custom_text_field.dart';
import 'package:toastification/toastification.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _fullNameTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _confirmPasswordTEC = TextEditingController();
  bool isValidationPassed = false;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFireStoreService _firebaseFireStoreService =
      FirebaseFireStoreService();

  void validatorFunction() async {
    if (_fullNameTEC.text.isEmpty ||
        _emailTEC.text.isEmpty ||
        _passwordTEC.text.isEmpty ||
        _confirmPasswordTEC.text.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: const Text("Please fill all form fields"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else if (!_emailTEC.text.contains("@") && !_emailTEC.text.contains(".")) {
      toastification.show(
        context: context,
        icon: const Icon(Icons.error),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Please enter a valid email address"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else if (_passwordTEC.text.length < 6) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        icon: const Icon(Icons.error),
        title: const Text("Password must be at least 6 characters"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else if (_confirmPasswordTEC.text != _passwordTEC.text) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: const Text("Passwords do not match"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else {
      setState(() {
        isValidationPassed = true;
      });
    }
  }

  Future<void> createAccount(
      {required String email,
      required String passWord,
      required String displayName,
      required BuildContext context}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    final result = await _firebaseAuthService.createUserWithEmailAndPassword(
        email: email, password: passWord, context: context);

    if (result != null) {
      await _firebaseFireStoreService.createNewUser(
          email: email, displayName: displayName, context: context);
    }
    _fullNameTEC.clear();
    _emailTEC.clear();
    _passwordTEC.clear();

    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    _fullNameTEC.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();
    _confirmPasswordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                verticalSpaceTiny,
                SvgPicture.asset(AppConstants.signUpSvg,
                    height: 250.v, width: 250.h),
                verticalSpaceMicroSmall,
                Text(
                  "Create Account",
                  style: kHeading2TextStyle.copyWith(
                      color: AppColors.kSecondaryColor),
                ),
                verticalSpaceMicro,
                CustomTextField(
                  inputController: _fullNameTEC,
                  hintText: "Full Name",
                ),
                verticalSpaceMicro,
                CustomTextField(
                  inputController: _emailTEC,
                  hintText: "Email Address",
                ),
                verticalSpaceMicro,
                CustomTextField(
                  inputController: _passwordTEC,
                  hintText: "Password",
                  isPassword: true,
                ),
                verticalSpaceMicro,
                CustomTextField(
                  inputController: _confirmPasswordTEC,
                  hintText: "Confirm Password",
                  isPassword: true,
                ),
                verticalSpaceMini,
                CustomButton(
                  onPressed: () async {
                    validatorFunction();

                    if (isValidationPassed) {
                      await createAccount(
                          displayName: _fullNameTEC.text.trim(),
                          email: _emailTEC.text.trim(),
                          passWord: _passwordTEC.text.trim(),
                          context: context);
                    }
                  },
                  backgroundColor: AppColors.kPrimaryColor,
                  text: "Sign Up",
                  size: Size(MediaQuery.of(context).size.width, 60),
                  style: kSubtitleRegularTextStyle.copyWith(
                      color: AppColors.kWhiteColor),
                ),
                verticalSpaceMicro,
                Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: kSubtitleRegularTextStyle.copyWith(
                            color: AppColors.kSecondaryColor.withOpacity(0.6)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInView()));
                          },
                          child:
                              Text("Login", style: kSubtitleRegularTextStyle))
                    ]))
              ]),
        ),
      ),
    ));
  }
}
