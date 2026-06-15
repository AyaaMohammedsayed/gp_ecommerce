/// Centralized API endpoint constants for the Kinetic backend.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://depi.shitos.org/api';

  // Auth
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String user = '$baseUrl/user';

  // Categories
  static const String categories = '$baseUrl/categories';
  static String categoryDetails(int id) => '$baseUrl/categories/$id';
  static String categoryProducts(int id) => '$baseUrl/categories/$id/products';

  // Products
  static const String products = '$baseUrl/products';
  static const String productOffers = '$baseUrl/products/offers';
  static String productDetails(int id) => '$baseUrl/products/$id';

  // Favorites
  static const String favorites = '$baseUrl/favorites';
  static String toggleFavorite(int productId) =>
      '$baseUrl/favorites/$productId/toggle';

  // Cart
  static const String cart = '$baseUrl/cart';
  static const String cartAdd = '$baseUrl/cart/add';
  static String cartItem(int cartItemId) => '$baseUrl/cart/$cartItemId';

  // Checkout
  static const String checkout = '$baseUrl/checkout';
}
