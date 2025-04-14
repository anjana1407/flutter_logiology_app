import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedCategory = ''.obs;
  var selectedBrand = ''.obs;
  var maxPrice = 0.0.obs;
  var page = 0.obs;
  final limit = 20;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  var categories = <String>[].obs;
  var brands = <String>[].obs;

  void extractCategoriesAndBrands() {
    final all = products;
    categories.value = all.map((e) => e.category).toSet().toList();
    brands.value = all.map((e) => e.brand).toSet().toList();
  }

  void fetchProducts({bool isNextPage = false}) async {
    if (!isNextPage) isLoading.value = true;

    page.value = isNextPage ? page.value + 1 : 0;
    final url =
        'https://dummyjson.com/products?limit=$limit&skip=${page.value * limit}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] == null) {
          throw Exception("No products found in response");
        }

        final List<Product> newProducts = List<Product>.from(
          data['products'].map((x) => Product.fromJson(x)),
        );

        if (isNextPage) {
          products.addAll(newProducts);
        } else {
          products.value = newProducts;
          extractCategoriesAndBrands(); // populate filters
        }
      } else {
        Get.snackbar("Error", "Failed to load products");
      }
    } catch (e, stacktrace) {
      print('Error fetching products: $e');
      print('StackTrace: $stacktrace');
      Get.snackbar("Error", "Something went wrong: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> get filteredProducts {
    var list = products;

    if (searchQuery.isNotEmpty) {
      list =
          list
              .where(
                (p) => p.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList()
              .obs;
    }

    if (selectedCategory.isNotEmpty) {
      list =
          list.where((p) => p.category == selectedCategory.value).toList().obs;
    }

    if (selectedBrand.isNotEmpty) {
      list = list.where((p) => p.brand == selectedBrand.value).toList().obs;
    }

    if (maxPrice.value > 0) {
      list = list.where((p) => p.price <= maxPrice.value).toList().obs;
    }

    return list;
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = '';
    maxPrice.value = 0.0;
  }
}
