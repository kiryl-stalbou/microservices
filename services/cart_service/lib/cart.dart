class Cart {
  final List<CartItem> items;

  const Cart(this.items);

  Cart.empty() : items = <CartItem>[];
}

class CartItem {
  final int quantity;
  final String productId;

  const CartItem(this.productId, this.quantity);

  Map<String, Object?> toJson() => <String, Object?>{
        'productId': productId,
        'quantity': quantity,
      };
}

final Map<String, Cart> cartByUserId = <String, Cart>{};
