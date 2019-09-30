import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imgColumn = "imgColumn";



class ContactHelper{
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();
  Database _db;

  get db async {
      if(_db != null)
          return _db;
       else
         return await _initDb();
  }


 Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contact.db" );
  return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      String sql = "CREATE TABLE $contactTable ( "
                   +" $idColumn INTEGER PRIMARY KEY, "
                   +" $nomeColumn TEXT, "
                   +" $emailColumn TEXT, "
                   +" $telefoneColumn TEXT, "
                   +" $imgColumn TEXT "
                   +")";
      await db.execute(sql);
    });
  }


  Future<Contact> saveContact(Contact contact) async {
   Database database = await db;
   contact.id = await database.insert(contactTable, contact.toMap());
   return contact;
  }

  Future<Contact> getContact(int id) async{
    Database database = await db;
    List<Map> maps = await database.query(contactTable,
    columns: [idColumn, nomeColumn, emailColumn, telefoneColumn, imgColumn],
      where: " $idColumn = ?",
      whereArgs: [id]);

    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteContact(int id) async{
    Database database = await db;
    return await database.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }


  Future<int> updateContact(Contact contact) async{
    Database database = await db;
    return await database.update(contactTable, contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]);
  }




  Future<List<Contact>> getAllcontact() async{
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM $contactTable ");
    return listMap.map( (value) => Contact.fromMap(value)).toList();
  }


  Future<int> getTotalContact() async{
    Database database = await db;
    return Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }


  Future close() async {
    Database database = await db;
    return database.close();
  }
}


class Contact{

  int id;
  String nome;
  String email;
  String telefone;
  String img;


  Contact();


  Contact.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
    img = map[imgColumn];
  }


  Map toMap(){

    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      imgColumn: img
    };

      if(id != null) {
        map[idColumn] = id;
      }

    return map;

  }


  @override
  String toString() {
    return "Contact(Id: $id, Nome: $nome, Email: $email, Telefone: $telefone, IMG: $img )";
  }


}