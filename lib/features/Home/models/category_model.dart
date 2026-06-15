import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String coverImage;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.coverImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      coverImage: json['cover_image'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, slug, coverImage];
}
