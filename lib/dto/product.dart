class Product {
  final String name;
  int counter;
  double price;
  double total;

  Product(
      {required this.name,
      this.counter = 0,
      this.price = 0.0,
      this.total = 0.0});

  Map<String, dynamic> toJson() => {
        'name': name,
        'counter': counter,
        'price': price,
        'total': total,
      };
}
