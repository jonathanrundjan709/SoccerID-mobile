import 'package:flutter/material.dart';
import 'package:soccerid/screens/newslist_form.dart';
import 'package:soccerid/widgets/left_drawer.dart';
import 'package:soccerid/widgets/news_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String nama = "Jonathan Yitskhaq Rundjan";
  final String npm = "2406435231";
  final String kelas = "C";

  late final List<ItemHomepage> items = [
    const ItemHomepage(
      "All Products",
      Icons.storefront,
      color: Colors.indigo,
      snackMessage: "Kamu telah menekan tombol All Products!",
    ),
    const ItemHomepage(
      "My Products",
      Icons.inventory_2,
      color: Colors.teal,
      snackMessage: "Kamu telah menekan tombol My Products!",
    ),
    ItemHomepage(
      "Add Products",
      Icons.add_circle,
      color: Colors.orange,
      snackMessage: "Kamu telah menekan tombol Add Products!",
      destinationBuilder: (context) => const NewsFormPage(),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Cards Row (NPM, Name, Class)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),
            
            const SizedBox(height: 16),

            // Welcome Section
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

            // Grid Menu Items
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