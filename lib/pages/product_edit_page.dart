import 'package:flutter/material.dart';
import 'package:products_app_demo/database/products_database.dart';
import 'package:products_app_demo/model/product.dart';
import 'package:products_app_demo/widgets/product_form_widget.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({Key? key, this.product}) : super(key: key);

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late bool isHealthy;
  late String name;
  late String description;
  ///Test: changed 'int quantity' to "String quantity" to resolve Type Case ERROR caused by 'onChanged':
  // late double price;
  late String price;
  ///Test: changed 'int quantity' to "String quantity" to resolve Type Case ERROR caused by 'onChanged':
  //late int quantity;
  late String quantity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isHealthy = widget.product?.isHealthy ?? false;
    quantity = "${widget.product?.quantity ?? 0}";
    price = "${widget.product?.price ?? 0.0}";
    name = widget.product?.name ?? '';
    description = widget.product?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        ///Test: Old code commented!
        child: ProductFormWidget(
          isHealthy: isHealthy,
          //number: number,
          name: name,
          description: description,
          quantity: quantity,
          price: price,
          onChangedHealthy: (isHealthy) =>
              setState(() => this.isHealthy = isHealthy),
          //onChangedNumber: (number) => setState(() => this.number = number),
          onChangedName: (name) => setState(() => this.name = name),
          onChangedDescription: (description) => setState(() => this.description = description),
          onChangedQuantity: (quantity) { setState(() {this.quantity=quantity;}); },
          onChangedPrice: (price) { setState(() {
            this.price=price;
          }); },
        ),
        ///Test: New code Added by me 'Oussama':
        // child: ListView(
        //   children: [
        //     TextFormField(),
        //     TextFormField()
        //   ],
        // ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = name.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateProduct,
        child: const Text('Save'),
      ),
    );
  }
 ///Function that interacts with the database:
  void addOrUpdateProduct() async{
    ///If the product already exists we call 'updateProduct()', if it doesn't exist we call 'addProduct()':
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      final isUpdating = widget.product!=null;
      if(isUpdating){
       await updateProduct();
      }else{
        addProduct();
      }

      Navigator.of(context).pop();
    }
  }
  ///Function that interacts with the database:
  Future updateProduct() async{
    final product = widget.product!.copy(
     isHealthy: isHealthy,
     name: name,
     description: description,
     price: double.parse(price),
     quantity: int.parse(quantity)
    );

    await ProductsDatabase.productDBInstance.update(product);
  }
  ///Function that interacts with the database:
  Future addProduct() async{
    final product = Product(
        isHealthy: isHealthy,
        name: name,
        description: description,
        price: double.parse(price),
        quantity: int.parse(quantity),
        time: DateTime.now()
    );

    await ProductsDatabase.productDBInstance.create(product);
  }
}
