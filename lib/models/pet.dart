// Pet modeli, API'dan alınan verileri temsil eder
// Bu, OpenAPI tarafından oluşturulan modeli kullanana kadar basit bir model olacak
class Pet {
  final int? id;
  final String? name;
  final String? status;
  final List<String>? photoUrls;
  final List<Tag>? tags;
  final Category? category;

  Pet({
    this.id,
    this.name,
    this.status,
    this.photoUrls,
    this.tags,
    this.category,
  });

  // JSON'dan model oluştur
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      photoUrls:
          json['photoUrls'] != null
              ? List<String>.from(json['photoUrls'])
              : null,
      tags:
          json['tags'] != null
              ? (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList()
              : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  // Modeli JSON'a dönüştür
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    if (photoUrls != null) {
      data['photoUrls'] = photoUrls;
    }
    if (tags != null) {
      data['tags'] = tags!.map((tag) => tag.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

// Pet'in kategori bilgisini temsil eden model
class Category {
  final int? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

// Pet etiketlerini temsil eden model
class Tag {
  final int? id;
  final String? name;

  Tag({this.id, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
