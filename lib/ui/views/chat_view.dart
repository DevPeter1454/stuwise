import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/response.dart';
import 'package:toastification/toastification.dart';
// import 'package:markdown/markdown.dart' ;

class ChatView extends StatefulWidget {
  final String prompt;
  const ChatView({super.key, required this.prompt});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String apiKey = 'AIzaSyDzHwuI20Rp1y70kCpHHfQg7vzKJ6nGVL0';

  final model = GenerativeModel(
      model: "gemini-pro", apiKey: "AIzaSyDzHwuI20Rp1y70kCpHHfQg7vzKJ6nGVL0");

  final List newprompts = prompts;

  bool isLoading = true;

  String responseText = "";

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    model.generateContent([Content.text(widget.prompt)]).then((value) {
      if (value.text!.isNotEmpty) {
        setState(() {
          responseText = value.text!;
        });
      }
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      if (error.toString().contains("Instance")) {
        final result = newprompts
            .firstWhere((element) => element["prompt"] == widget.prompt);
        setState(() {
          responseText = result["response"];
        });
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          icon: const Icon(Icons.error),
          style: ToastificationStyle.flatColored,
          title: Text(error.toString()),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.prompt),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/background.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Visibility(
            visible: !isLoading,
            replacement: const Center(child: CircularProgressIndicator()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(widget.prompt,
                            style: kSubtitleTextStyle.copyWith(
                                color: AppColors.kWhiteColor))),
                  ),
                ),
                SizedBox(height: 16.v),
                Expanded(
                  child: Markdown(
                    shrinkWrap: true,
                    data: responseText,
                    controller: controller,
                  ),
                ),
                SizedBox(height: 16.v),
              ],
            ),
          )),
    );
  }
}
