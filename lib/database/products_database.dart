import 'package:products_app_demo/model/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///To persist the products entered by the user:
class ProductsDatabase{
  ///private named constructor of this class:
  ProductsDatabase._init();
  ///Global field (instance of this class):
  static final ProductsDatabase productDBInstance = ProductsDatabase._init();
  ///Calling an instance of SQLFlit library:
  static Database? _database;
  ///Create a connection to the DB before "create, read, update, delete" THROUGH a 'Function':
  Future<Database> get getDatabase async{
    if(_database!=null){
      return _database!;
    }else{
      _database= await _initDB('products_db');
      return _database!;
    }
  }
  ///Initialize our database + storing our DB in our File Storage System:
  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    ///join the database File 'dbPath' TO the 'filePath':
    final path = join(dbPath, filePath);
    ///Open the database:
    return openDatabase(path, version: 1, onCreate: _createDB);

  }
  ///define the Database schema of our table BY '_createDB' + define our columns inside the table:
  ///The function '_createDB' executes ONLY IF the database table isn't exist yet:
  Future _createDB(Database db, int version) async{
    ///The type of our columns inside the database table:
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const booleanType = "BOOLEAN NOT NULL";
    const integerType = "INTEGER NOT NULL";
    const doubleType = "DOUBLE NOT NULL";

    await db.execute('''
       CREATE TABLE $tableProducts (
          ${ProductFields.id}  $idType,
          ${ProductFields.name}  $textType,
          ${ProductFields.description}  $textType,
          ${ProductFields.isHealthy}  $booleanType,
          ${ProductFields.price}  $doubleType,
          ${ProductFields.quantity}  $integerType,
          ${ProductFields.createdTime} 
          
          )
          ''');
  }
  ///To PERFORM the 'create, read, update AND delete':
  ///Persist a product inside our database:
  Future<Product> create(Product product) async{
    ///Getting the database reference:
    final db = await productDBInstance.getDatabase;
    ///If we want to pass our own SQL Statement inside:
    // final json = product.toJson();
    // final columns = '${ProductFields.name}, ${ProductFields.description}, ${ProductFields.quantity}, ${ProductFields.price}';
    // final values = '${json[ProductFields.name]}, ${json[ProductFields.description]}, ${json[ProductFields.quantity]}'
    //                 '${json[ProductFields.price]}';
    // final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    ///Convert our Product object INTO a Json object:
    ///To put the data that we want inside in a collection map in our database THROUGH the 'toJson()' method:
    final id = await db.insert(tableProducts, product.toJson());
    ///After got the 'id' THEN we pass it to the Product object THROUGH 'product.copy':
    return product.copy(id: id);
  }
  ///To read a Product object from the database:
  Future<Product> readProduct(int id) async{
    final db = await productDBInstance.getDatabase;

    final maps = await db.query(
      tableProducts,
      columns: ProductFields.values,
      where: '${ProductFields.id} = ? ',
      whereArgs: [id],
    );
    ///We need to CONVERT(1) our List of Json object to a Product object:
    if(maps.isNotEmpty){
      return Product.convertFromJson(maps.first);
    }else{
      throw Exception('ID $id is not found!');
    }

  }
  ///To read All products:
  Future<List<Product>> readAllProducts() async{
    final db = await productDBInstance.getDatabase;
    const orderByTime = '${ProductFields.createdTime} ASC';
    final result = await db.query(tableProducts, orderBy: orderByTime);
    ///We need to CONVERT each our Json object in the List of Json objects to a List of Product objects:
    return result.map((json) => Product.convertFromJson(json)).toList();
  }
  ///To update a Product:
  Future<int> update(Product product) async {
    final db = await productDBInstance.getDatabase;

    return db.update(
        tableProducts,
        product.toJson(),
        where: '${ProductFields.id} = ?',
        whereArgs: [product.id]
    );
  }
  ///To delete a Product object from the database:
  Future<int> delete(int id) async{
    final db = await productDBInstance.getDatabase;

    return await db.delete(
        tableProducts,
        where: '${ProductFields.id} = ?',
        whereArgs: [id]
    );
  }

  ///To close the Database:
  Future close() async{
    final db = await productDBInstance.getDatabase;
    db.close();
  }

}