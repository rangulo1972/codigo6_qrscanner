import 'dart:math';

import 'package:flutter/material.dart';

import 'package:qr/Data/Services/local/db_admin.dart';
import 'package:qr/Domain/models/qr_model.dart';
import 'package:qr/Presentation/global/dialogs/my_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCustomListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //** para el uso de un mejor manejo en la pantalla del equipo */
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double diagonal = sqrt(pow(heigth, 2) + pow(width, 2));
    //**--------------------------------------------------------- */
    return FutureBuilder(
      future: DBAdmin().getQRList(),
      //! poner completo BuildContext y AsyncSnapshot para que tener conflicto
      //! sobre posible null en el retorno
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //! creamos la instancia del tipo QRModel para poder traer los
          //! los atributos del getQRList de nuestro db_admin
          List<QrModel> qrList = snapshot.data;
          return qrList.isNotEmpty
              ? ListView.builder(
                  //! para poder realizar el scroll en pantalla
                  physics: const NeverScrollableScrollPhysics(),
                  //! esto para evitar conflicto en cuanto a los scrolls
                  //! y se adapte el ListView a su itemCount
                  shrinkWrap: true,
                  itemCount: qrList.length,
                  itemBuilder: (context, index) {
                    //! procedemos a validar si la url captada contiene http
                    bool isUrl = false;
                    if (qrList[index].url.contains("http")) {
                      isUrl = true;
                    }
                    //!------------------------------------------------
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          //! El expanded para que no tener dificultades al llenar
                          //! los datos en el ListView con los textos ingresados
                          Expanded(
                            child: Column(
                              //** para alinear a todos al inicio de la izquierda */
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      qrList[index].datetime,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  qrList[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  qrList[index].observation,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //** usando el validador de url procedemos */
                          isUrl
                              ? IconButton(
                                  onPressed: () {
                                    Uri uri = Uri.parse(qrList[index].url);
                                    //! con esto lanzamos a una aplicación externa
                                    launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  },
                                  icon: const Icon(
                                    Icons.link,
                                    color: Colors.white,
                                  ))
                              : const SizedBox(),
                          //**--------------------------------------- */
                          IconButton(
                              onPressed: () {
                                //** capturamos la data necesaria  */
                                final datetime = qrList[index].datetime;
                                final title = qrList[index].title;
                                final observation = qrList[index].observation;
                                final url = qrList[index].url;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MyAlertDialog(
                                        datatime: datetime,
                                        title: title,
                                        observation: observation,
                                        url: url);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.qr_code,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    );
                  },
                )
              :
              //** mensaje que se visualizará si no hay data registrada */
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/box.png",
                            height: diagonal * 0.4,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "No hay data registrada...",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      )),
                );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
