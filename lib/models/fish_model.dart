
class Fish {
  final String id;
  final String name;
  final double price;
  final String location;
  final String imageUrl;
  final String description;
  final String category;
  final bool isMine;
  final int views;
  final String sellerName;
  final String sellerImage;
  final String breed;
  final String age;

  Fish({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.imageUrl,
    this.description = '',
    this.category = '',
    this.isMine = false,
    this.views = 0,
    this.sellerName = 'Unknown Seller',
    this.sellerImage = '',
    this.breed = '',
    this.age = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'isMine': isMine,
      'views': views,
      'sellerName': sellerName,
      'sellerImage': sellerImage,
      'breed': breed,
      'age': age,
    };
  }

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isMine: json['isMine'] as bool? ?? false,
      views: json['views'] as int? ?? 0,
      sellerName: json['sellerName'] as String? ?? 'Unknown Seller',
      sellerImage: json['sellerImage'] as String? ?? '',
      breed: json['breed'] as String? ?? '',
      age: json['age'] as String? ?? '',
    );
  }

  Fish copyWith({
    String? id,
    String? name,
    double? price,
    String? location,
    String? imageUrl,
    String? description,
    String? category,
    bool? isMine,
    int? views,
    String? sellerName,
    String? sellerImage,
    String? breed,
    String? age,
  }) {
    return Fish(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      isMine: isMine ?? this.isMine,
      views: views ?? this.views,
      sellerName: sellerName ?? this.sellerName,
      sellerImage: sellerImage ?? this.sellerImage,
      breed: breed ?? this.breed,
      age: age ?? this.age,
    );
  }
}
