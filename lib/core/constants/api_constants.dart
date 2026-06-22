class ApiConstants {
  static const String baseUrl = 'https://kinetic-electronics.lol/api/';

  // Auth
  static const String register = 'register';
  static const String login = 'login';
  static const String user = 'user';
  static const String logout = 'logout';

  // Categories
  static const String categories = 'categories';
  static String categoryDetails(int id) => 'categories/$id';
  static String categoryProducts(int id) => 'categories/$id/products';

  // Products
  static const String products = 'products';
  static const String productOffers = 'products/offers';
  static String productDetails(int id) => 'products/$id';

  // Favorites
  static const String favorites = 'favorites';
  static String toggleFavorite(int productId) => 'favorites/$productId/toggle';

  // Cart
  static const String cart = 'cart';
  static const String cartAdd = 'cart/add';
  static String cartItem(int cartItemId) => 'cart/$cartItemId';

  // Checkout
  static const String checkout = 'checkout';
}
