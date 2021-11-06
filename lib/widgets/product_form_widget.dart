import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


///Test: Old code commented!
class ProductFormWidget extends StatelessWidget {
  ///Test: TextEditingController added:
 // TextEditingController textEditingController ? 'null' : 0;
  final bool? isHealthy;
  // final int? quantity;
  final String? quantity;
  final String? name;
  final String? description;
  final String? price;
  // final double? price;
  final ValueChanged<bool> onChangedHealthy;
  ///Test: the type 'ValueChanged<int>' of "onChangedQuantity" displays an ERROR Type Cast with 'onChanged String?'!
  // final ValueChanged<int> onChangedQuantity;
  final ValueChanged<String> onChangedQuantity;
  // final ValueChanged<double> onChangedPrice;
  final ValueChanged<String> onChangedPrice;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDescription;

      ProductFormWidget({
    Key? key,
    this.isHealthy = false,
    this.quantity = '0',
    this.price = '0.0',
    this.name = '',
    this.description = '',
    required this.onChangedHealthy,
    required this.onChangedQuantity,
    required this.onChangedName,
    required this.onChangedDescription,
    required this.onChangedPrice
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Switch(
                value: isHealthy ?? false,
                onChanged: onChangedHealthy,
              ),
              //Expanded(child: Slider(value: (quantity ?? 0).toDouble(), min: 0, max: 5, divisions: 5, onChanged: (quantity) => onChangedQuantity(quantity.toInt()),))
            ],
          ),
          buildName(),
          const SizedBox(height: 8),
          buildDescription(),
          const SizedBox(height: 12),
          buildQuantity(),
          const SizedBox(height: 18),
          buildPrice(),
        ],
      ),
    ),
  );

  Widget buildName() => TextFormField(
    maxLines: 1,
    initialValue: name,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type the name of the product',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (name) =>
    name != null && name.isEmpty ? 'The name cannot be empty!' : null,
    onChanged: onChangedName,
  );

  Widget buildDescription() => TextFormField(
    maxLines: 5,
    initialValue: description,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type the description of the product...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (description) => description != null && description.isEmpty
        ? 'The description cannot be empty!'
        : null,
    onChanged: onChangedDescription,
  );
  Widget buildQuantity() => TextFormField(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    maxLines: 5,
    initialValue: quantity,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type the quantity of product...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (quantity) => quantity != null && quantity.isEmpty
        ? 'The quantity cannot be empty!'
        : null,
    // TODO: Error was in here (type cast)
     onChanged: onChangedQuantity,
    //onEditingComplete: ()=> quantity=onChangedQuantity as int?,
  );
  Widget buildPrice() => TextFormField(
    initialValue: price,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    // inputFormatters: [FilteringTextInputFormatter.digitsOnly
    // ],
   // initialValue: price,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type the price product...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (price) => price != null && price.isEmpty
        ? 'The price cannot be empty!'
        : null,
    // TODO: Error was in here (type cast)
    onChanged: onChangedPrice,
  );

}