import 'package:flutter/material.dart';
import 'package:soccerid/widgets/left_drawer.dart';

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  static const routeName = '/add-product';

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  double _price = 0;
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

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = "";
      _price = 0;
      _description = "";
      _category = "jersey";
      _thumbnail = "";
      _isFeatured = false;
    });
  }

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk Baru',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                  value: _category,
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
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Produk berhasil tersimpan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama: $_title'),
                                    Text('Harga: Rp${_price.toStringAsFixed(2)}'),
                                    Text('Deskripsi: $_description'),
                                    Text('Kategori: $_category'),
                                    Text('Thumbnail: $_thumbnail'),
                                    Text('Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _resetForm();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
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