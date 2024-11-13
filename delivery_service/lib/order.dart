class Order {
  final String userId;
  final String address;

  Order(this.userId, this.address);

  Map<String, String> toJson() {
    return {
      'userId': userId,
      'address': address,
    };
  }
}

final Map<String, Order> orderByUserId = {};
