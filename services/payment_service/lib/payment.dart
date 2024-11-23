class Payment {
  final String orderId;
  final double amount;

  const Payment(this.orderId, this.amount);

  Map<String, Object?> toJson() => <String, Object?>{
        'orderId': orderId,
        'amount': amount,
      };
}

final Map<String, List<Payment>> paymentsByUserId = <String, List<Payment>>{};
