import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController ctr;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obsecuredText;
  final TextInputType? inputType;
  final String? hintText;
  final int? lines;
  const CustomTextField({
    required this.ctr,
    this.suffixIcon,
    this.prefixIcon,
    this.obsecuredText = false,
    this.inputType,
    this.hintText,
    this.lines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctr,
      obscureText: obsecuredText,
      keyboardType: inputType,
      maxLines: lines ?? 1,
      style: GoogleFonts.philosopher(),
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.h),
          border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          filled: true,
          // fillColor: Colors.white,
          fillColor: Colors.grey.withOpacity(0.25),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon),
    );
  }
}
