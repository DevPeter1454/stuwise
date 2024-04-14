import 'package:stuwise/ui/constants/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? validationMessage;
  final TextEditingController? inputController;
  final bool autoFocus;
  final bool hasValidationMessage;
  final bool isPassword;
  final FocusNode? focusNode;
  final BoxConstraints? constraints;
  final String? optionalText;
  final TextInputType? textInputType;
  final String? labelText;
  final bool? isEnabled;

  const CustomTextField(
      {super.key,
      required this.hintText,
      this.validationMessage,
      this.inputController,
      this.autoFocus = false,
      this.hasValidationMessage = false,
      this.isPassword = false,
      this.focusNode,
      this.constraints,
      this.optionalText,
      this.textInputType,
      this.labelText,
    
      this.isEnabled = true});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passwordVisibility = false;
  bool hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      debugLabel: "Scope",
      autofocus: true,
      
      child: Focus(
        child: Builder(builder: (context) {
          return TextFormField(
            cursorColor: AppColors.kPrimaryColor,
            textAlign: TextAlign.start,
            
            keyboardType: widget.textInputType,
            textAlignVertical: TextAlignVertical.center,
            style: kSubtitleRegularSmallTextStyle.copyWith(
                color: AppColors.kSecondaryColor),
            controller: widget.inputController,
            autofocus: widget.autoFocus,
            inputFormatters: widget.textInputType == TextInputType.phone
                ? [
                    LengthLimitingTextInputFormatter(14),
                  ]
                : null,
            obscureText:
                widget.isPassword == true ? !passwordVisibility : false,
            // onTapOutside: (event) {
            //   if (widget.hintText == 'Phone Number') {
            //     setState(() {
            //       hasFocus = false;
            //     });
            //   }
            // },
            // onEditingComplete: () {
            //   if (widget.hintText == 'Phone Number') {
            //     setState(() {
            //       hasFocus = false;
            //     });
            //   }
            // },
            // onChanged: (value) {
            //   if (widget.hintText == 'Phone Number') {
            //     setState(() {
            //       hasFocus = true;
            //     });
            //   }
            // },
            decoration: InputDecoration(
              suffixIcon: widget.isPassword == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          passwordVisibility = !passwordVisibility;
                        });
                      },
                      icon: Icon(
                        passwordVisibility == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.kSecondaryColor.withOpacity(0.6),
                      ),
                    )
                  : null,
              enabled: widget.isEnabled ?? false,
              hintText: widget.optionalText != null
                  ? '${widget.hintText} (Optional)'
                  : widget.hintText,
              hintStyle: kHintText.copyWith(
                color: AppColors.kSecondaryColor.withOpacity(0.6),
              ),
              filled: true,
              fillColor: Colors.grey.shade300,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.kSecondaryColor.withOpacity(0.7),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.kNeutralColor,
                ),
              ),
              constraints: widget.constraints,
            ),
          );
        }),
      ),
    );
  }
}
