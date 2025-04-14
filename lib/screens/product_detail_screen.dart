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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.thumbnail,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(product.description),
            const SizedBox(height: 10),
            Text(
              'Price: \$${product.price}',
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              'Rating: ${product.rating}',
              style: const TextStyle(color: Colors.amber),
            ),
            Text('Category: ${product.category}'),
            Text('Brand: ${product.brand}'),
          ],
        ),
      ),
    );
  }
}
