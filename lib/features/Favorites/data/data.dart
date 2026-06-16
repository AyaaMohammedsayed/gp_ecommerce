// موديل المنتج
class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isFavorite = true,
  });
}

// Repository وهمي للبيانات
abstract class FavoritesRepository {
  Future<List<Product>> getFavorites();
  Future<void> removeFavorite(String productId);
  Future<void> addToCart(Product product);
}

// تطبيق وهمي (هتعدليه لما تجيبي بيانات حقيقية)
class FavoritesRepositoryImpl implements FavoritesRepository {
  @override
  Future<List<Product>> getFavorites() async {
    // بيانات مؤقتة زي الـ UI بالضبط
    return [
      Product(
        id: '1',
        name: 'AERO-X1 HEADPHONES',
        price: 540,
        description: 'Studio-grade acoustic meets premium wireless integrity.',
        imageUrl: 'https://via.placeholder.com/80', // استبدلي بالصورة الحقيقية
      ),
      Product(
        id: '2',
        name: 'KINETIC TYPE-S',
        price: 169,
        description: 'Engineered for precision. Crafted for the tactile artistry.',
        imageUrl: 'https://via.placeholder.com/80',
      ),
      Product(
        id: '3',
        name: 'LUMINA X-PRO',
        price: 2499,
        description: 'The ultimate tool for cinematic storytelling and high-res video.',
        imageUrl: 'https://via.placeholder.com/80',
      ),
    ];
  }

  @override
  Future<void> removeFavorite(String productId) async {
    // هانضيف منطق الحذف هنا
  }

  @override
  Future<void> addToCart(Product product) async {
    // هانضيف منطق إضافة للسلة هنا
  }
}