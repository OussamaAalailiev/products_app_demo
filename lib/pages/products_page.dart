import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:products_app_demo/database/products_database.dart';
import 'package:products_app_demo/model/product.dart';
import 'package:products_app_demo/pages/product_detail_page.dart';
import 'package:products_app_demo/pages/product_edit_page.dart';
import 'package:products_app_demo/widgets/product_card_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  ///Properties of the state of the page:
  late List<Product> products;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshProducts();
  }

  @override
  void dispose() {
    ProductsDatabase.productDBInstance.close();
    super.dispose();
  }

  Future refreshProducts() async{
    setState(() {
      isLoading = true;
    });

    products = await ProductsDatabase.productDBInstance.readAllProducts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(fontSize: 25),),
        centerTitle: true,
        actions: const [Icon(Icons.search), SizedBox(width: 12,)],
      ),
      body: Center(
        child: isLoading ? const CircularProgressIndicator()
                         : products.isEmpty ? const Text('No Products found', style: TextStyle(color: Colors.white))
                         : buildProducts(),
      ),
      floatingActionButton: FloatingActionButton(
         onPressed: () async{
           await Navigator.of(context).push(MaterialPageRoute(
               builder: (context)=> AddEditProductPage()
           ));

           refreshProducts();
         },
         backgroundColor: Colors.black,
         child: const Icon(Icons.add),
      ),
    );
  }
  ///To build the grid view:
  Widget buildProducts() => StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      mainAxisSpacing: 4,
      crossAxisCount: 4,
    staggeredTileBuilder: (index)=> const StaggeredTile.fit(2),
      itemBuilder:  (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailPage(productId: product.id!),
            ));

            refreshProducts();
          },
          child: ProductCardWidget(product: product, index: index),
        );
      },
  );
}
