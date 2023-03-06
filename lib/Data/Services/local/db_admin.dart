import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr/Domain/models/qr_model.dart';

class DBAdmin {
  //! implementación de Singleton para un mejor manejo del objeto de DBAmin
  static final DBAdmin _instance = DBAdmin._();
  DBAdmin._();
  factory DBAdmin() {
    return _instance;
  }

  //! indicamos que puede ser null porque es el que manejará la DB
  Database? _myDatabase;

  //! para verificar la existencia de la DB, para ser utilizada
  //! colocamos el ? ya que la Database puede ser null si no existiera
  //! al momento que se realiza el check de dicha DB
  Future<Database?> _checkDatabase() async {
    //! expresión resumida para el condicional si al no existir la DB y la
    //! tabla la crea, caso contrario la retorna
    _myDatabase ??= await _initDatabase();
    return _myDatabase;
  }

  //! para la creación de la DB en forma local
  //! siempre será un Future que devuelva un objeto del tipo DataBase
  Future<Database> _initDatabase() async {
    //! con esto tenemos la dirección donde se creará la DB local
    Directory myDirectory = await getApplicationDocumentsDirectory();
    //! estructuramos el path para apuntar al directorio (myDirectory)
    //! para la creación del DB colocando nombre de dicha DB
    String pathDatabase = join(myDirectory.path, "QrDB.db");
    //! openDatabase es un Future que crea la Db y la Tabla
    //! y lo asignamos a la variable database para ser retornada
    Database database = await openDatabase(
      //**-- posicionamiento del path en la dirección del directorio  */
      //! procedemos a crear la tabla en la DB local
      pathDatabase,
      //**-- necesita de una versión inicial */
      version: 1,
      //** creación de la tabla con lenguaje SQL */
      onCreate: (db, version) async {
        await db.execute(
            " CREATE TABLE QR(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, observation TEXT, url TEXT, datetime TEXT)");
      },
    );
    return database;
  }

  //! creación del CRUD
  //**--- Visualizar (Red) */
  Future<List<QrModel>> getQRList() async {
    final Database? db = await _checkDatabase(); //* ? porque puede ser null
    List data = await db!.query("QR"); //* ! ya existe la tabla
    //! creamos una lista de Modelo a partir de un Map para un mejor manejo
    //! para no tener que trabajar con los datos que se tiene un Map y cometer
    //! errores al momento de invocar la data
    List<QrModel> qrList = data.map((e) => QrModel.fromJson(e)).toList();
    return qrList;
  }

  //**---- insertar(Create) */
  Future<int> insertQR(QrModel model) async {
    final Database? db = await _checkDatabase(); //* ? porque puede ser null
    //**----- hacemos uso de .toJson porque se acomoda al modelo de qr_model */
    int value = await db!.insert("QR", model.toJson());
    return value;
  }
}
