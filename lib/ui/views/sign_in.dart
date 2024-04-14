import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/bottom_nav_view.dart';
import 'package:stuwise/ui/views/sign_up.dart';
import 'package:stuwise/ui/widgets/custom_text_button.dart';
import 'package:stuwise/ui/widgets/custom_text_field.dart';
import 'package:toastification/toastification.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  bool isValidationPassed = false;

  void validatorFunction() {
    if (_emailTEC.text.isEmpty || _passwordTEC.text.isEmpty) {
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
    } else {
      setState(() {
        isValidationPassed = true;
      });
    }
  }

  Future<void> signInToAccount() async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    await _firebaseAuthService.signInWithEmailAndPassword(
        email: _emailTEC.text, password: _passwordTEC.text, context: context);

    _emailTEC.clear();
    _passwordTEC.clear();
    setState(() {
      isValidationPassed = false;
    });

    EasyLoading.dismiss();

    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavView()));
  }

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: StreamBuilder<User?>(
              stream: _firebaseAuthService.currentStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return const BottomNavView();
                }
                return signInViewWidget(context);
              })),
    );
  }

  SingleChildScrollView signInViewWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            verticalSpaceTiny,
            SvgPicture.asset(AppConstants.signInSvg,
                height: 250.v, width: 250.h),
            verticalSpaceMicroSmall,
            Text(
              "Welcome",
              style:
                  kHeading2TextStyle.copyWith(color: AppColors.kSecondaryColor),
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
            verticalSpaceSmall,
            CustomButton(
              onPressed: () async {
                validatorFunction();
                if (isValidationPassed) {
                  await signInToAccount();
                }
              },
              backgroundColor: AppColors.kPrimaryColor,
              text: "Login",
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
                    "Don't have an account?",
                    style: kSubtitleRegularTextStyle.copyWith(
                        color: AppColors.kSecondaryColor.withOpacity(0.6)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()));
                      },
                      child: Text("Sign Up", style: kSubtitleRegularTextStyle))
                ]))
          ],
        ),
      ),
    );
  }
}
