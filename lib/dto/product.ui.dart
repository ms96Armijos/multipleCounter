import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multiplecounter/dto/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String nonEmptyProducts = "";
  double totalOrder = 0.0;
  List<Product> products = [
    Product(name: 'Product 1', price: 5.0),
    Product(name: 'Product 2', price: 9.6),
    Product(name: 'Product 3', price: 1.5),
    Product(name: 'Product 4', price: 6.25),
    Product(name: 'Product 5', price: 7.50),
    Product(name: 'Product 6', price: 20.0),
    Product(name: 'Product 7', price: 15.60),
    Product(name: 'Product 8', price: 18.50),
    Product(name: 'Product 9', price: 20.5),
    Product(name: 'Product 10', price: 10.25),
  ];

  void _updateCounter(int index, int operation) {
    if (products[index].counter == 0 && operation == -1) {
      return; // No permitir decrementar si el contador es 0
    }

    setState(() {
      products[index].counter += operation;
      products[index].total = products[index].price * products[index].counter;
      totalOrder += products[index].price * operation;
    });
  }

  Future<void> _sendData() async {
    final nonEmptyProductsList =
        products.where((product) => product.total != 0).toList();
    final jsonData = jsonEncode(
        nonEmptyProductsList.map((product) => product.toJson()).toList());

    setState(() {
      nonEmptyProducts = jsonData;
      totalOrder =
          nonEmptyProductsList.fold(0.0, (sum, product) => sum + product.total);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 146, 132, 118),
      appBar: AppBar(
        title: const Text('Counters of Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendData,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildListProduct()),
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (nonEmptyProducts.isEmpty)
                    const Text(
                      'No products selected.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  else
                    Text(
                      'Selected Products: $nonEmptyProducts',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: \$${totalOrder.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListProduct() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          color: const Color.fromARGB(255, 232, 212, 169),
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(products[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Price: \$${products[index].price.toStringAsFixed(2)}'),
                const SizedBox(height: 5),
                Text('Quantity: ${products[index].counter}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _updateCounter(index, -1),
                  icon: const Icon(Icons.remove, size: 24),
                ),
                Text(
                  '${products[index].counter}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _updateCounter(index, 1),
                  icon: const Icon(Icons.add, size: 24),
                ),
              ],
            ),
            subtitle: Text(
              'Total: \$${products[index].total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
