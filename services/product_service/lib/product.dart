class Product {
  final String productId;
  final String name;
  final double price;

  const Product(this.productId, this.name, this.price);

  Map<String, Object?> toJson() => <String, Object?>{
        'productId': productId,
        'name': name,
        'price': price,
      };
}

final Map<String, Product> productById = <String, Product>{};
