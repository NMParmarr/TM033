import 'package:eventflow/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Txt extends StatelessWidget {
  final String title;
  final Color? bgColor;
  final Color? textColor;
  final double? fontsize;
  final FontWeight? fontweight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const Txt(this.title,
      {super.key,
      this.bgColor,
      this.textColor,
      this.fontsize,
      this.fontweight,
      this.textAlign,
      this.overflow,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.philosopher(
        backgroundColor: bgColor,
        color: textColor ?? Colors.black,
        fontSize: fontsize,
        fontWeight: fontweight,
      ),
    );
  }
}

Widget RichTxt({required String firstTxt, required String SecondTxt}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
            text: firstTxt,
            style: GoogleFonts.roboto(
                fontSize: 2.t,
                fontWeight: FontWeight.w500,
                color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: " :  $SecondTxt",
                style: GoogleFonts.roboto(
                    fontSize: 2.t,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              )
            ]),
      ),
    );
