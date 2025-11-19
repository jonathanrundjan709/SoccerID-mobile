import 'dart:convert';

List<Product> productFromJson(String str) => 
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String id;
    String name;
    int price;
    String description;
    String thumbnail;
    String category;
    int stock;
    bool isFeatured;
    int userId;

    Product({
        required this.id,
        required this.name,
        required this.price,
        required this.description,
        required this.thumbnail,
        required this.category,
        required this.stock,
        required this.isFeatured,
        required this.userId,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        price: json["price"] ?? 0,
        description: json["description"] ?? "",
        thumbnail: json["thumbnail"] ?? "",
        category: json["category"] ?? "",
        stock: json["stock"] ?? 0,
        isFeatured: json["is_featured"] ?? false,
        userId: json["user_id"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "stock": stock,
        "is_featured": isFeatured,
        "user_id": userId,
    };
}