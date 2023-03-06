import 'package:flutter/material.dart';
import 'dart:math';

import 'package:qr/Presentation/global/widgets/common_button_widget.dart';
import 'package:qr/Presentation/global/widgets/colors.dart';
import 'package:qr/Presentation/pages/history_page.dart';
import 'package:qr/Presentation/pages/scanner_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double diagonal = sqrt(pow(width, 2) + pow(height, 2));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SaveQR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Gestiona los códigos QR de tu preferencia.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Image.asset(
                "assets/images/qr.png",
                width: diagonal * 0.5,
              ),
              CommonButtonWidget(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScannerPage(),
                      ));
                },
                text: "Escanear QR",
              ),
              const SizedBox(
                height: 12,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(),
                      ));
                },
                child: const Text(
                  "Ver historial",
                  style: TextStyle(
                    color: kBrandPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
