class Review {
  final String productId;
  final String userId;
  final int rating;
  final String comment;

  const Review(this.productId, this.userId, this.rating, this.comment);

  Map<String, Object?> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}

final Map<String, List<Review>> reviewsByProductId = <String, List<Review>>{};
