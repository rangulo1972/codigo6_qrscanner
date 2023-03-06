import 'package:flutter/material.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';

class MyAlertDialog extends StatelessWidget {
  String datatime;
  String title;
  String observation;
  String url;

  MyAlertDialog(
      {required this.datatime,
      required this.title,
      required this.observation,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Fecha: $datatime",
              style: const TextStyle(fontSize: 12),
            ),
            Text("Título: $title",
                style: const TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text("Observación: $observation",
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(
              url,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
          const SizedBox(height: 20),
          //**------ presentanción del QR--------- */
          CustomPaint(
            painter: QrPainter(
                data: url,
                options: const QrOptions(
                  shapes: QrShapes(
                    darkPixel: QrPixelShapeRoundCorners(cornerFraction: 0.5),
                    frame: QrFrameShapeRoundCorners(cornerFraction: 0.25),
                    ball: QrBallShapeRoundCorners(cornerFraction: 0.25),
                  ),
                  colors: QrColors(
                    dark: QrColorLinearGradient(colors: [
                      Color.fromARGB(255, 255, 0, 0),
                      Color.fromARGB(255, 0, 0, 255),
                    ], orientation: GradientOrientation.leftDiagonal),
                  ),
                )),
            size: const Size(250, 250),
          ),
          //**------fin presentación del QR--------- */
        ],
      ),
    );
  }
}
