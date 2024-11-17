class Cart {
  final List<CartItem> items;

  const Cart(this.items);
}

class CartItem {
  final int quantity;
  final String productId;

  const CartItem(this.productId, this.quantity);

  Map<String, Object?> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

final Map<String, Cart> cartByUserId = <String, Cart>{};
