///Define our table by the name:
const String tableProducts = 'products';

///Naming the column names of our database table THROUGH 'ProductFields' class + using the sql naming conventions BY
/// accepting ONE type 'String' ->text :
class ProductFields{
  
  static final List<String> values = [///add all columns in this list:
                                   id, name, description, isHealthy, price, quantity, createdTime];
  
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String isHealthy = 'isHealthy';
  static const String price = 'price';
  static const String quantity = 'quantity';
  static const String createdTime = 'createdTime';
}

class Product{

  final int? id;
  final String name;
  final String description;
  final bool isHealthy;
  ///Test: changed 'double price' to "String price" to resolve Type Case ERROR caused by 'onChanged':
  // final String price;
  final double price;
  ///Test: changed 'int quantity' to "String quantity" to resolve Type Case ERROR caused by 'onChanged':
  final int quantity;
  //final double totalPriceQuantity;
  //final String quantity;
  final DateTime time;

  Product({this.id, required this.name, required this.description, required this.isHealthy,
           required this.quantity, required this.price, required this.time});
  
  ///'tJson()' to put our implement the Product fields AND convert them into Json Object THROUGH KEY VALUE MAP
  /// + data binding of 'ProductFields' WITH 'Product':
  ///Convert our Product object INTO a Json object:
  Map<String, Object?> toJson() => {
    ProductFields.id : id,
    ProductFields.name : name,
    ProductFields.description : description,
    ///We should convert the bool 'isHealthy' to an INTEGER because that what the sql database understands:
    /// if 'isHealthy' is true we return 1 otherwise we return 0 in case if it was false:
    ProductFields.isHealthy : isHealthy ? 1 : 0,
    ProductFields.price : price,
    ProductFields.quantity : quantity,
    ///Convert also the 'DateTime' to a String:
    ProductFields.createdTime : time.toIso8601String()
  };
  
  ///'copy()' To do data binding between the Product object AND Json object returned inside the other class:
  Product copy({int? id, String? name, String? description,
                bool? isHealthy, double? price, int? quantity, DateTime? createdTime,
               }) => Product(
                             id: id ?? this.id,
                             name: name ?? this.name,
                             description: description ?? this.description,
                             isHealthy: isHealthy ?? this.isHealthy,
                             price: price ?? this.price,
                             quantity: quantity ?? this.quantity,
                             time: createdTime ?? time
                             );
  
  ///Convert FROM json object TO a Product object:
  static Product convertFromJson(Map<String, Object?> json) => Product(
    id: json[ProductFields.id] as int?,
    name: json[ProductFields.name] as String,
    description: json[ProductFields.description] as String,
    isHealthy: json[ProductFields.isHealthy]==1,
    quantity: json[ProductFields.quantity] as int,
    price: json[ProductFields.price] as double,
    time: DateTime.parse(json[ProductFields.createdTime] as String),
  );

  ///Trying to calculate the total price:
  // Future<double> getTotalPrice() async{
  //   double result= price * quantity;
  //   return result;
  // }


}