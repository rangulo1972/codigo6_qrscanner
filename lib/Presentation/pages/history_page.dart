import 'package:flutter/material.dart';
import 'package:qr/Presentation/global/dialogs/custom_list_view.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print(DBAdmin().getQRList()); //* para ver si trae la data del DB local
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Historial de contenido",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Listado general de los registros",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              //* creamos el widget ListView para visualizar la data guardada
              //* dentro de la DB local
              MyCustomListView(),
            ],
          ),
        ),
      )),
    );
  }
}
