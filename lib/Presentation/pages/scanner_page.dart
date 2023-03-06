import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr/Presentation/global/widgets/common_button_widget.dart';
import 'package:qr/Presentation/global/widgets/colors.dart';
import 'package:qr/Presentation/pages/register_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  //** atributos propios de la libería externa usada para scan del QR */
  Barcode? result;

  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //**------------------------------------------------------------ */
  //! variable para contener la data que se scanea desde el visor y ser enviado
  //! a register_page para ser almacenado en la DB
  String urlData = "";

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        //**-- para poder ver en consola */
        if (result != null && result!.code != null) {
//          print(":::> ${result!.code}");
          urlData = result!.code!;
        }
        //**---- fin poder ver en consola */
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: kBrandPrimaryColor,
          borderRadius: 16,
          borderLength: 32,
          borderWidth: 8,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(flex: 4, child: _buildQrView(context)),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            color: Colors.white10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  //! para poder mostrar el valor escaneado
                  urlData.isEmpty ? "QR a ser scanear" : urlData,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                CommonButtonWidget(
                  onPressed: urlData.isNotEmpty
                      ? () {
                          //**-- para liberar recurso del equipo que lee  */
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(url: urlData),
                            ),
                          );
                        }
                      : null,
                  text: "Resgistrar QR",
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
