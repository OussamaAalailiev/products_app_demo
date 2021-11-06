import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:products_app_demo/database/products_database.dart';
import 'package:products_app_demo/model/product.dart';
import 'package:products_app_demo/pages/product_edit_page.dart';

class ProductDetailPage extends StatefulWidget {
  ///In order to reference our product id:
  final int productId;

  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Product product;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshProduct();
  }

  Future refreshProduct() async{
    setState(() {
      isLoading = true;
    });
    product = await ProductsDatabase.productDBInstance.readProduct(widget.productId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ///Test:
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
             ?  const Center(child: CircularProgressIndicator())
             :  Padding(
                         padding: const EdgeInsets.all(14),
                         child: ListView(
                           padding: const EdgeInsets.symmetric(vertical: 8),
                           children: [
                             Text(
                               product.name,
                               style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 22,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             const SizedBox(height: 8),
                             Text(
                               DateFormat.yMMMd().format(product.time),
                               style: const TextStyle(color: Colors.white38),
                             ),
                             const SizedBox(height: 8),
                             Text(
                               product.description,
                               style: const TextStyle(color: Colors.white70, fontSize: 18),
                             )
                           ],
                         )
      ),
    );
  }
  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined, color: Colors.green,),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditProductPage(product: product),
        ));

        refreshProduct();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete, color: Colors.red,),
    onPressed: () async {
      await ProductsDatabase.productDBInstance.delete(widget.productId);

      Navigator.of(context).pop();
    },
  );
}
