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

  void _incrementDecrementCounter(int index, String operation) {
    if (products[index].counter <= 0 && operation == 'decrement') {
      return;
    }

    setState(() {
      operation == 'increment'
          ? products[index].counter++
          : products[index].counter--;
      products[index].price;
      products[index].total = products[index].price * products[index].counter;
      operation == 'increment'
          ? totalOrder += products[index].price
          : totalOrder -= products[index].price;
    });
  }

  Future<void> _sendData() async {
    // Filtrar products con total diferente de cero
    List<Product> productsNoVacios =
        products.where((producto) => producto.total != 0).toList();

    // Convertir la lista filtrada a JSON
    nonEmptyProducts = jsonEncode(
        productsNoVacios.map((products) => products.toJson()).toList());

    setState(() {
      if (nonEmptyProducts.isEmpty) {
        totalOrder = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 146, 132, 118),
      appBar: AppBar(
        title: const Text('Counteres de Products'),
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
          SizedBox(
            height: 150.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      nonEmptyProducts,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total \$${totalOrder.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
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
            title: Column(children: [
              Text('Cant.: ${products[index].counter}'),
              Text('Price: \$ ${products[index].price}'),
            ]),
            leading: Text(products[index].name),
            trailing: SizedBox(
              width: 220.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        _incrementDecrementCounter(index, 'decrement'),
                    child: const Text('-',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _incrementDecrementCounter(index, 'increment'),
                    child: const Text('+',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Total: ${products[index].total.toStringAsFixed(2)},',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
