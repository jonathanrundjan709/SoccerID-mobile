import 'package:flutter/material.dart';

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final String snackMessage;
  final WidgetBuilder? destinationBuilder;

  const ItemHomepage(
    this.name,
    this.icon, {
    required this.color,
    required this.snackMessage,
    this.destinationBuilder,
  });
}

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(item.snackMessage)),
            );

          if (item.destinationBuilder != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: item.destinationBuilder!,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}