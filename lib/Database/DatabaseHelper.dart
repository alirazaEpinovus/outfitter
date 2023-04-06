import 'dart:io';
import 'package:outfitters/Models/CartModel.dart';
import 'package:outfitters/Models/ScanHistroyModel.dart';
import 'package:outfitters/Models/WishlistModel.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final String databaseName = "Order.db";
  static final int datavaseVersion = 1;
  static final String orderTable = "OrderTable";
  static final String orderID = "order_id";
  static final String value = "p_value";
  static final String productName = "p_name";
  static final String productID = "p_id";
  static final String productColor = "p_color";
  static final String productSize = "p_size";
  static final String productImage = "p_image";
  static final String varientID = "varient_id";
  static final String price = "price";
  static final String comparePrice = "compare_price";
  static final String sku = "sku";
  static final String quantity = "quantity";
  static final String graphQl = "graphid";

  static final String wishlistTable = "wishlistTable";
  static final String wishproductName = "wishproduct_name";
  static final String wishproductId = "id";
  static final String wishValue = "p_value";

  static final String wishproductGraphQl = "graphid";
  static final String wishproductImage = "wishproduct_image";
  static final String productPrice = "wishproduct_price";
  static final String isFaviourite = "isFav";
  static final String onlineStoreurl = "onlineStoreUrl";
  static final String available = "available";

  static final String scanhistroyTable = "scanHistroy";
  static final String itemid = "scanrecentid";
  static final String scanproductSku = "scancode";

  final String createProductTable = " CREATE TABLE " +
      orderTable +
      " (" +
      orderID +
      " INTEGER PRIMARY KEY AUTOINCREMENT, " +
      productName +
      " TEXT, " +
      productID +
      " TEXT, " +
      productColor +
      " TEXT, " +
      productSize +
      " TEXT, " +
      varientID +
      " TEXT, " +
      value +
      " TEXT, " +
      productImage +
      " TEXT, " +
      quantity +
      " INTEGER, " +
      price +
      " INTEGER, " +
      comparePrice +
      " INTEGER, " +
      sku +
      " TEXT," +
      graphQl +
      " TEXT ," +
      available +
      " TEXT " +
      ")";

  // second table create for wishlist
  final String createWishlistTable = " CREATE TABLE " +
      wishlistTable +
      " (" +
      wishproductId +
      " INTEGER PRIMARY KEY AUTOINCREMENT, " +
      wishproductGraphQl +
      " TEXT, " +
      wishproductName +
      " TEXT, " +
      wishValue +
      " TEXT, " +
      wishproductImage +
      " TEXT, " +
      productPrice +
      " INTEGER, " +
      isFaviourite +
      " TEXT, " +
      onlineStoreurl +
      " TEXT, " +
      available +
      " TEXT " +
      ")";

  // third table for recent view products
  final String createScanTable = " CREATE TABLE " +
      scanhistroyTable +
      " (" +
      itemid +
      " INTEGER PRIMARY KEY AUTOINCREMENT, " +
      scanproductSku +
      " TEXT " +
      ")";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path,
        version: datavaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(createProductTable);
    // wiishlist table
    await db.execute(createWishlistTable);
    // scanhistroy
    await db.execute(createScanTable);
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, context) async {
    Database db = await instance.database;

    try {
      // await db.insert(orderTable, row);
      var list = await db.query(orderTable,
          where: '$varientID = ?', whereArgs: [row['varient_id']]);
      print("============${list.first[quantity]}=======");
      int c = list.first[quantity];
      c < 5
          ? Toast.showToast(context, 'Added to Cart Successfully!')
          : Toast.showToast(context, "You can not add more than 5 items");

      return list.length == 0
          ? await db.insert(orderTable, row)
          : c < 5
              ? await update(
                  list.first[orderID], c + int.parse(row['quantity']))
              : await update(list.first[orderID], list.first[quantity]);
    } catch (SQLException) {
      return await db.insert(orderTable, row);
    }
  }

  Future<int> insertWishlist(Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.insert(wishlistTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<CartModel>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(orderTable);

    List<CartModel> list =
        res.isNotEmpty ? res.map((c) => CartModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<WishListModel>> wishqueryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(wishlistTable);

    List<WishListModel> list = res.isNotEmpty
        ? res.map((c) => WishListModel.fromJson(c)).toList()
        : [];

    return list;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $orderTable'));
  }

  Future<bool> checkwishexist(String graphid) async {
    try {
      Database db = await instance.database;
      var list = await db.query(wishlistTable,
          where: '$wishproductGraphQl = ?', whereArgs: [graphid]);

      return list.length == 0 ? false : true;
    } catch (SQLException) {
      return false;
    }
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(int id, int quant) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'Update $orderTable Set $quantity = $quant Where $orderID = $id');
  }

  Future<int> delete() async {
    Database db = await instance.database;
    return await db.delete(orderTable);
  }

  Future<int> deleteAllWish() async {
    Database db = await instance.database;
    return await db.delete(wishlistTable);
  }

  Future<int> deletewish(String graphid) async {
    Database db = await instance.database;
    return await db.delete(wishlistTable,
        where: '$wishproductGraphQl = ?', whereArgs: [graphid]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteItem(int id) async {
    Database db = await instance.database;
    return await db.delete(orderTable, where: '$orderID = ?', whereArgs: [id]);
  }

  Future<int> insertRecentScan(String scancode) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {"scancode": scancode};
    var list = await db.query(scanhistroyTable,
        where: '$scanproductSku = ?', whereArgs: [scancode]);

    if (list.isEmpty) {
      print('add success');
      return await db.insert(scanhistroyTable, row);
    } else {
      print('not success');
      return 200;
    }
  }

  Future<List<ScanHistroyModel>> getRecentScan() async {
    Database db = await instance.database;
    var res = await db.query(scanhistroyTable);

    List<ScanHistroyModel> list = res.isNotEmpty
        ? res.map((e) => ScanHistroyModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<int> scanhistroyCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $scanhistroyTable'));
  }

  Future<int> deletescanitem(int id) async {
    Database db = await instance.database;
    return await db
        .delete(scanhistroyTable, where: '$itemid = ?', whereArgs: [id]);
  }

  Future<int> deleteScanHistroy() async {
    Database db = await instance.database;
    return await db.delete(scanhistroyTable);
  }
}
