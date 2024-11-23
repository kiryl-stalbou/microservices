class Review {
  final String productId;
  final int rating;
  final String comment;

  const Review(this.productId, this.rating, this.comment);

  Map<String, Object?> toJson() => <String, Object?>{
        'productId': productId,
        'rating': rating,
        'comment': comment,
      };
}

final Map<String, List<Review>> reviewsByProductId = <String, List<Review>>{};
