class Order {
  final String address;

  Order(this.address);

  Map<String, String> toJson() => <String, String>{
        'address': address,
      };
}

final Map<String, Order> orderByUserId = <String, Order>{};
