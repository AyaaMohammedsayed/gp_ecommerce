// import 'package:equatable/equatable.dart';

// class CartItem extends Equatable{
//   final String productId;
//   final String name;
//   final double price;
//   final String imageUrl;
//   final String? description;
//   final int quantity;
//   final bool inStock;
//   final bool freeShipping;

//   const CartItem({
//     required this.name,
//     required this.productId,
//     required this.price,
//     required this.imageUrl,
//     this.description,
//     this.quantity = 1,
//     this.inStock = true,
//     this.freeShipping = false,
//   });

//   double get totalPrice => price * quantity;
//   String get displayQty => quantity.toString().padLeft(2, '0'); //i put this to display digits

//   CartItem copyWith({
//     // TODO: implement the  8 properties minus (last three)
//   }) {}


// } 