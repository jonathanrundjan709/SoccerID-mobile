import 'package:flutter/material.dart';
import 'package:soccerid/models/product_entry.dart';
import 'package:soccerid/widgets/left_drawer.dart';
import 'package:soccerid/screens/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryListPage extends StatefulWidget {
  final bool showMyProductsOnly;
  
  const ProductEntryListPage({
    super.key,
    this.showMyProductsOnly = false,
  });

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  static const String baseUrl = 'http://localhost:8000';
  
  late bool _showMyProductsOnly;

  @override
  void initState() {
    super.initState();
    _showMyProductsOnly = widget.showMyProductsOnly;
  }

  Future<List<Product>> fetchProducts(CookieRequest request, bool myProductsOnly) async {
    try {
      final url = myProductsOnly 
          ? '$baseUrl/json/?filter=my'      // My products
          : '$baseUrl/json/?filter=all';     // All products
      
      print('Fetching products from: $url');
      final response = await request.get(url);
      
      print('Response type: ${response.runtimeType}');
      print('Response: $response');
      
      // Convert json data to Product objects
      List<Product> listProduct = [];
      if (response is List) {
        print('Data is List with ${response.length} items');
        for (var d in response) {
          if (d != null) {
            try {
              print('Parsing product: $d');
              listProduct.add(Product.fromJson(d));
            } catch (e) {
              print('Error parsing product: $e');
              print('Product data: $d');
              continue;
            }
          }
        }
      } else {
        print('Data is not a List! Type: ${response.runtimeType}');
      }
      
      print('Successfully parsed ${listProduct.length} products');
      return listProduct;
    } catch (e, stackTrace) {
      print('Error fetching products: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: const Color(0xFFf97316),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          // Filter buttons section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showMyProductsOnly = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showMyProductsOnly 
                          ? const Color(0xFFf97316)
                          : Colors.white,
                      foregroundColor: !_showMyProductsOnly 
                          ? Colors.white 
                          : Colors.black87,
                      side: BorderSide(
                        color: !_showMyProductsOnly 
                            ? const Color(0xFFf97316)
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: !_showMyProductsOnly ? 2 : 0,
                    ),
                    child: const Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showMyProductsOnly = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showMyProductsOnly 
                          ? const Color(0xFFf97316)
                          : Colors.white,
                      foregroundColor: _showMyProductsOnly 
                          ? Colors.white 
                          : Colors.black87,
                      side: BorderSide(
                        color: _showMyProductsOnly 
                            ? const Color(0xFFf97316)
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: _showMyProductsOnly ? 2 : 0,
                    ),
                    child: const Text(
                      'My Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Product list
          Expanded(
            child: FutureBuilder<List<Product>>(
              key: ValueKey(_showMyProductsOnly),
              future: fetchProducts(request, _showMyProductsOnly),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 16, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _showMyProductsOnly 
                              ? 'You have no products yet.'
                              : 'There are no products in football shop yet.',
                          style: const TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.data![index].thumbnail.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                snapshot.data![index].thumbnail,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Center(
                                      child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Text(
                            snapshot.data![index].name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Price: Rp${snapshot.data![index].price}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFFf97316),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Category: ${snapshot.data![index].category}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Stock: ${snapshot.data![index].stock}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            snapshot.data![index].description.length > 100
                                ? '${snapshot.data![index].description.substring(0, 100)}...'
                                : snapshot.data![index].description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          if (snapshot.data![index].isFeatured)
                            const Text(
                              'Featured Product',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    product: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFf97316),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('View Detail'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}