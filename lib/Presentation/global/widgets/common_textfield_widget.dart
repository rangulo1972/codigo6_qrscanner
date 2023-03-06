import 'package:flutter/material.dart';

class CommonTextfieldWidget extends StatelessWidget {
  String hintText; //* usado para poder ingresar el texto como referencia
  TextEditingController controller; //* usado para captura de la data
  bool?
      isRequired; //* usado como flag para indicar si es requerido o no un campo
  CommonTextfieldWidget(
      {required this.hintText, required this.controller, this.isRequired});

  @override
  Widget build(BuildContext context) {
    //! debido a la creación del widget Form en resgiter y un key de validación
    //! debemos cambiar de TextField a TextFormField para poder realizar los
    //! campos de validación
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white30,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        //! para el manejo de los errores cuando no se ingresa data en los
        //! campos requeridos
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      //! creación de la validación del TextFormField que se realizará
      //! cuando se inserte los datos solicitados para el register_page
      //! para que no graben la DB sin datos
      validator: (String? value) {
        if (value != null && value.isEmpty && isRequired == true) {
          return "Campo obligatorio";
        }
        return null;
      },
    );
  }
}
