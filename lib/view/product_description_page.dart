import 'package:flutter/material.dart';
import 'package:gemicates/Utils/app_colors.dart';
import '../model/product_model.dart'; // Assuming this is your product model

class ProductDescriptionPage extends StatelessWidget {
  final Product product;

  const ProductDescriptionPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          product.title,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            product.description,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          _buildDetailRow('Category', product.category),
          _buildDetailRow('Price', '\$${product.price.toStringAsFixed(2)}'),
          _buildDetailRow(
              'Discount Percentage', '${product.discountPercentage}%'),
          _buildRatingRow('Rating', product.rating),
          _buildDetailRow('Dimensions',
              'W:${product.dimensions.width} x H:${product.dimensions.height} x D:${product.dimensions.depth}'),
          _buildDetailRow('Warranty Information', product.warrantyInformation),
          _buildReviewsSection(product.reviews),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(List<ProductReview> reviews) {
    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Reviews (${reviews.length})',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reviews.map((review) {
            return ListTile(
              title: Text(review.reviewerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.comment),
                  const SizedBox(height: 4.0),
                  Text(review.date),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
