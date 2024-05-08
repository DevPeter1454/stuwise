import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import "package:stuwise/ui/constants/exports.dart";

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFireStoreService _firebaseFireStoreService =
      FirebaseFireStoreService();
  Map<String, dynamic> userDetails = {};
  bool isLoading = true;

  Future<void> getUserDetails() async {
    final result = await _firebaseFireStoreService.getUserDetails(context);
    if (result != null) {
      setState(() {
        userDetails = result;
        isLoading = false;
      });
    }
    
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/background.png",
          ),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Visibility(
            visible: !isLoading,
            replacement: const Center(child: CircularProgressIndicator()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Hello, ${userDetails['displayName'].toString().split(" ")[0]}",
                      style: kHeading1TextStyle.copyWith(fontSize: 30.fsize)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                SvgPicture.asset(AppConstants.revenuSvg,
                    height: 150.v, width: 150.h),
                verticalSpaceMicro,
                Text(
                  "Plan for the days ahead",
                  style: kHeading2TextStyle,
                ),
                verticalSpaceMicro,
                Text(
                  "Set up a loan repayment schedule",
                  style: kSubtitleRegularTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}
