class Payment {
  final String userId;
  final String orderId;
  final double amount;

  const Payment(this.userId, this.orderId, this.amount);

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'orderId': orderId,
      'amount': amount,
      'status': 'paid', // Example static status
    };
  }
}

final Map<String, List<Payment>> paymentByUserId = <String, List<Payment>>{};
