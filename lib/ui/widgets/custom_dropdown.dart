import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/ui/constants/exports.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> dropdownItems;
  final Function onChanged;
  final String? value;
  final String? hintText;
  const CustomDropdown(
      {super.key,
      required this.dropdownItems,
      required this.onChanged,
      this.value,
      this.hintText});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: widget.value,
      iconStyleData: IconStyleData(
        icon: const Icon(Icons.arrow_drop_down_rounded),
        iconEnabledColor: AppColors.kPrimaryColor.withOpacity(0.4),
        iconDisabledColor: AppColors.kPrimaryColor.withOpacity(0.4),
        iconSize: 40,
      ),
      buttonStyleData: ButtonStyleData(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 0, right: 0),
      ),
      items: widget.dropdownItems
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: kSubtitleRegularTextStyle.copyWith(fontSize: 12),
                ),
              ))
          .toList(),
      onChanged: (value) {
        widget.onChanged(value);
      },
      dropdownStyleData: DropdownStyleData(
        direction: DropdownDirection.textDirection,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      ),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hintText,
        hintStyle: kHintText,
        filled: true,
        fillColor: AppColors.kNeutralColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 14.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.kPrimaryColor.withOpacity(0.7),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.kNeutralColor,
          ),
        ),
      ),
    );
  }
}
