import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soccerid/screens/login.dart';
import 'package:soccerid/screens/product_entry_list.dart';
import 'package:soccerid/screens/productlist_form.dart';
import 'package:soccerid/widgets/left_drawer.dart';
import 'package:soccerid/widgets/menu_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  static const String baseUrl = 'http://localhost:8000';

  final String nama = "Jonathan Yitskhaq Rundjan";
  final String npm = "2406435231";
  final String kelas = "C";

  late final List<ItemHomepage> items = [
    ItemHomepage(
      "See Products",
      Icons.storefront,
      color: const Color(0xFFf97316),
      snackMessage: "Membuka daftar produk!",
      destinationBuilder: (context) => const ProductEntryListPage(),
    ),
    ItemHomepage(
      "Add Products",
      Icons.add_circle,
      color: const Color(0xFFf97316),
      snackMessage: "Kamu telah menekan tombol Add Products!",
      destinationBuilder: (context) => const ProductEntryFormPage(),
    ),
    ItemHomepage(
      "Logout",
      Icons.logout,
      color: Colors.red,
      snackMessage: "Logging out...",
      onTap: (context) async {
        final request = context.read<CookieRequest>();
        // 🎯 Logout dengan URL hardcoded
        final response = await request.logout('$baseUrl/auth/logout/');  // ⚠️ Sesuaikan
        final message = response["message"];
        if (!context.mounted) return;
        if (response['status']) {
          final uname = response["username"];
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("$message See you again, $uname.")),
            );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Football Shop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFf97316),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),
            const SizedBox(height: 16),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Selamat datang di Football Shop',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                primary: true,
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}