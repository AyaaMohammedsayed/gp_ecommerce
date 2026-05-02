import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String iconAsset;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconAsset,
  });

  @override
  List<Object?> get props => [id, name, iconAsset];
}
