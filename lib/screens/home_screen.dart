import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog(context, controller);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.to(() => ProfileScreen()),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Search...',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = controller.filteredProducts;
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (!controller.isLoading.value &&
                scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
              controller.fetchProducts(isNextPage: true);
            }
            return true;
          },

          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, i) {
              final p = products[i];
              return GestureDetector(
                onTap: () => Get.to(() => ProductDetailScreen(product: p)),
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        p.thumbnail,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "\$${p.price}",
                        style: TextStyle(color: Colors.green),
                      ),
                      Text("⭐ ${p.rating}"),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showFilterDialog(BuildContext context, ProductController controller) {
    final priceController = TextEditingController();
    String? selectedCategory;
    String? selectedBrand;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Products'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items:
                        controller.categories
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => selectedCategory = val!,
                    decoration: InputDecoration(labelText: 'Select Category'),
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: selectedBrand,
                    items:
                        controller.brands
                            .map(
                              (brand) => DropdownMenuItem(
                                value: brand,
                                child: Text(brand),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => selectedBrand = val!,
                    decoration: InputDecoration(labelText: 'Select Tag/Brand'),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Max Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.resetFilters();
                Get.back();
              },
              child: Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.selectedCategory.value = selectedCategory ?? '';
                controller.selectedBrand.value = selectedBrand ?? '';
                controller.maxPrice.value =
                    double.tryParse(priceController.text.trim()) ?? 0.0;
                Get.back();
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
