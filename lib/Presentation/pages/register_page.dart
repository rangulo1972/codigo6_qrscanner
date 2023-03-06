import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qr/Domain/models/qr_model.dart';
import 'package:qr/Data/Services/local/db_admin.dart';
import 'package:qr/Presentation/pages/home_page.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:qr/Presentation/global/widgets/common_button_widget.dart';
import 'package:qr/Presentation/global/widgets/common_textfield_widget.dart';

class RegisterPage extends StatelessWidget {
  //! creamos la variable que recogerá el valor de la url obtenida desde
  //! la página de scanner_page y ser almacenada en la DB local
  String url;
  //**-- constructor que solicita este parámetro desde scaner_page */
  RegisterPage({required this.url});

  //! definimos los controladores de los TextField para el manejo de los datos
  //! ingresados desde el teclado
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  //! creamos un key para el proceso de la validaciones del formulario
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                //! insertamos el widget Form para apoder realizar la validación
                //! de los datos ingresados para el registro
                child: Form(
                  key: _formKey, //* key para la validación de datos ingresados
                  child: Column(
                    children: [
                      const Text(
                        "Registrar contenido",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Llenar los campos solicitados",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CommonTextfieldWidget(
                        hintText: "Ingrese un título...",
                        controller: _titleController,
                        isRequired: true, //* indicamos que es requerido
                      ),
                      const SizedBox(height: 20),
                      CommonTextfieldWidget(
                        hintText: "Comentarios / observaciones...",
                        controller: _observationController,
                        isRequired: true, //* indicamos que es requerido
                      ),
                      const SizedBox(height: 20),
                      //! generador de código QR a paratir de la data escaneada
                      CustomPaint(
                        painter: QrPainter(
                          data: url, //! data capturada desde el scanner_page
                          options: const QrOptions(
                            shapes: QrShapes(
                              darkPixel:
                                  QrPixelShapeRoundCorners(cornerFraction: .5),
                              frame:
                                  QrFrameShapeRoundCorners(cornerFraction: .25),
                              ball:
                                  QrBallShapeRoundCorners(cornerFraction: .25),
                            ),
                            colors: QrColors(
                                dark: QrColorLinearGradient(colors: [
                              Color.fromARGB(255, 32, 32, 31),
                              Color.fromARGB(255, 32, 32, 31),
                            ], orientation: GradientOrientation.leftDiagonal)),
                          ),
                        ),
                        size: const Size(250, 250),
                      ),
                      //! fin de generador de código QR a partir de la data escaneada
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CommonButtonWidget(
                onPressed: () {
                  //! uso de la validación en el llenado de los datos
                  if (_formKey.currentState!.validate()) {
                    //! hacemos que el teclado salga de pantalla una vez que se
                    //! ingresaron los datos para poder grabarlos
                    FocusScopeNode myFocusScope = FocusScope.of(context);
                    myFocusScope.unfocus();
                    //**-------------------------------------------------- */
                    //! modificamos el formato de fecha que vamos a usar en
                    //! el registro de la DB
                    DateFormat myFormat = DateFormat("dd/MM/yyyy hh:mm a");
                    String myDate = myFormat.format(DateTime.now());
                    //**---------------------------------------------------- */
                    //! creación del modelo QrModel para poder ser insertado
                    //! en la tabla de DB local
                    QrModel model = QrModel(
                        //! al controller agregarle el .text para toString()
                        title: _titleController.text,
                        observation: _observationController.text,
                        url: url, //* data obtenida desde el scanner_page
                        datetime: myDate);
                    //**--------------------------------------------------------- */
                    //! hacemos uso del Future.delay para poder insertar la data
                    //! sin problemas
                    Future.delayed(const Duration(milliseconds: 400), (() {
                      //! con el uso de singleton podemos llamar directamente
                      //! para la inserción de los datos que son capturados en
                      //! model, se obtiene un Future del tipo int
                      DBAdmin().insertQR(model).then((value) {
                        if (value >= 0) {
                          //! hacemos que después de pulsar grabar, no regresemos
                          //! hasta home_page
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (route) => false);
                          //!-------------------------------------------------
                          //* creación de un snackbar para indicar si los datos
                          //* fueron ingresados a la DB
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 73, 160, 163),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                behavior: SnackBarBehavior.floating,
                                content: const Text("Data resgistrada...")),
                          );
                        }
                      });
                    }));
                  }
                },
                text: "Guardar",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
