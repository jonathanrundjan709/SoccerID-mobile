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
      "Semua Produk",
      Icons.storefront,
      color: Colors.indigo,
      snackMessage: "Kamu telah menekan tombol Semua Produk!",
    ),
    const ItemHomepage(
      "Produk Favorit",
      Icons.inventory_2,
      color: Colors.teal,
      snackMessage: "Kamu telah menekan tombol Produk Favorit!",
    ),
    ItemHomepage(
      "Tambah Produk",
      Icons.add_circle,
      color: Colors.orange,
      snackMessage: "Kamu telah menekan tombol Tambah Produk!",
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
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  InfoCard(title: 'NPM', content: npm),
                  InfoCard(title: 'Name', content: nama),
                  InfoCard(title: 'Class', content: kelas),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Selamat datang di Football Shop',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aplikasi katalog perlengkapan sepak bola favoritmu.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width > 900
                      ? 4
                      : width > 600
                          ? 3
                          : 2;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: items
                        .map((item) => ItemCard(item))
                        .toList(growable: false),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 180,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
