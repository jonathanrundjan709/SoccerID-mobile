import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:soccerid/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soccerid/screens/product_entry_list.dart';

class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  static const routeName = '/add-product';

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  static const String baseUrl = 'http://localhost:8000'; 
  
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  double _price = 0;
  int _stock = 0;
  String _description = "";
  String _category = "jersey";
  String _thumbnail = "";
  bool _isFeatured = false;

  final List<String> _categories = const [
    'jersey',
    'boots',
    'merch',
    'training',
    'collection',
  ];

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk Baru',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFf97316),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama produk",
                    labelText: "Nama Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => _title = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama produk tidak boleh kosong!";
                    }
                    if (value.trim().length < 3) {
                      return "Nama produk minimal 3 karakter.";
                    }
                    return null;
                  },
                ),
              ),

              // Harga Produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Harga produk",
                    labelText: "Harga Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    setState(() {
                      _price = double.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Harga produk tidak boleh kosong!";
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null) {
                      return "Harga harus berupa angka.";
                    }
                    if (parsed <= 0) {
                      return "Harga harus lebih besar dari 0.";
                    }
                    return null;
                  },
                ),
              ),

              // Stock Produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Stok produk",
                    labelText: "Stok Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _stock = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Stok produk tidak boleh kosong!";
                    }
                    final parsed = int.tryParse(value);
                    if (parsed == null) {
                      return "Stok harus berupa angka bulat.";
                    }
                    if (parsed < 0) {
                      return "Stok tidak boleh negatif.";
                    }
                    return null;
                  },
                ),
              ),

              // Deskripsi Produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Tuliskan deskripsi singkat produk",
                    labelText: "Deskripsi Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => _description = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    if (value.trim().length < 10) {
                      return "Deskripsi minimal 10 karakter.";
                    }
                    return null;
                  },
                ),
              ),

              // Kategori Produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _category = value);
                  },
                ),
              ),

              // URL Thumbnail
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "https://contoh.com/produk.jpg",
                    labelText: "URL Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => _thumbnail = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "URL thumbnail tidak boleh kosong!";
                    }
                    if (!_isValidUrl(value.trim())) {
                      return "Gunakan URL yang valid (http/https).";
                    }
                    return null;
                  },
                ),
              ),

              // Is Featured
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: const Text("Tandai sebagai Produk Unggulan"),
                  value: _isFeatured,
                  onChanged: (value) => setState(() => _isFeatured = value),
                ),
              ),

              // Tombol Simpan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(0xFFf97316)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final productData = jsonEncode({
                          "name": _title,
                          "price": _price.toInt(),
                          "description": _description,
                          "category": _category,
                          "thumbnail": _thumbnail,
                          "stock": _stock,
                          "is_featured": _isFeatured,
                        });

                        try {
                          // 🎯 POST ke backend dengan URL hardcoded
                          final response = await request.postJson(
                            '$baseUrl/create-flutter/',  // ⚠️ Sesuaikan dengan URL backend
                            productData,
                          );

                          if (context.mounted) {
                            if (response['status'] == 'success' || response['status'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Produk berhasil ditambahkan!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductEntryListPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    response['message'] ?? 'Gagal menambahkan produk',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}