// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonLogo extends StatelessWidget {
  const CommonLogo({
    Key? key,
    required this.logoWidth,
    required this.logoHeight,
  }) : super(key: key);
  final double logoHeight;
  final double logoWidth;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/pursue_logo.svg',
          width: logoWidth,
          height: logoHeight,
        ),
        SizedBox(height: 2),
        Text(
          "Pursue",
          style: GoogleFonts.roboto(
            color: Color(0xff414042),
            fontSize: 35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
