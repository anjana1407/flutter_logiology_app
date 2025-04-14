import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.thumbnail, height: 250),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 10),
            Text('Price: \$${product.price}'),
            Text('Rating: ${product.rating}'),
            Text('Category: ${product.category}'),
          ],
        ),
      ),
    );
  }
}
