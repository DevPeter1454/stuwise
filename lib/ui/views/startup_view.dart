import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/sign_up.dart';
import 'package:stuwise/ui/widgets/custom_text_button.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(AppConstants.revenuSvg,
                          height: 250.v, width: 250.h),
                      verticalSpaceMicro,
                      Text(
                        "Welcome to StuWise",
                        style: kHeading1TextStyle,
                      ),
                      verticalSpaceMicroSmall,
                      Text(
                        "StuWise is your ultimate student loan repayment companion",
                        style: kBodyRegularTextStyle,
                      ),
                      verticalSpaceMicro,
                      Center(
                        child: CustomButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const SignUpView()));
                            },
                            size: Size(MediaQuery.of(context).size.width, 60),
                            backgroundColor: AppColors.kPrimaryColor,
                            text: "Get Started",
                            borderRadius: BorderRadius.circular(100),
                            style: kSubtitleRegularTextStyle.copyWith(
                                color: AppColors.kWhiteColor)),
                      )
                    ],
                  ),
                ))));
  }
}
