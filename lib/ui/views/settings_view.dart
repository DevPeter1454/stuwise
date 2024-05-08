import 'package:flutter/material.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/widgets/custom_text_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/background.png",
          ),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: kEdgeInsetsAllNormal,
          child: Visibility(
            visible: !isLoading,
            replacement: const Center(child: CircularProgressIndicator()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.kPrimaryColor,
                  child: Text(
                    userDetails['displayName']
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    style: kHeading1TextStyle.copyWith(
                        color: AppColors.kWhiteColor),
                  ),
                ),
                SizedBox(height: 16.v),
                ProfileDetailWidget(value: "${userDetails['displayName']}"),
                SizedBox(height: 16.v),
                ProfileDetailWidget(value: "${userDetails['email']}"),
                SizedBox(height: 16.v),
                CustomButton(
                    onPressed: () async{
                      await _firebaseAuthService.signOut(context: context);
                    },
                    text: "Log Out",
                    size: Size(MediaQuery.of(context).size.width, 60),
                    backgroundColor: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                    style: kSubtitleRegularTextStyle.copyWith(
                        color: AppColors.kWhiteColor))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDetailWidget extends StatelessWidget {
  final String value;
  const ProfileDetailWidget({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.v,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.kPrimaryColor, width: 2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: kHeading1TextStyle.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 18.fsize,
                  color: AppColors.kTextDefaultColor),
            ),
          ),
        ),
      ),
    );
  }
}
