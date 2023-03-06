import 'package:flutter/material.dart';
import 'package:qr/Presentation/global/widgets/colors.dart';
//import 'package:qr/Presentation/pages/scanner_page.dart';

class CommonButtonWidget extends StatelessWidget {
  Function? onPressed;
  String text;

  CommonButtonWidget({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed != null
            ? () {
                onPressed!();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kBrandPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: kBrandSecondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
