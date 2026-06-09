import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Cart/view/widgets/kinetic_bottom_nav.dart';
import 'package:gp_ecommerce/features/Cart/view/widgets/order_summary_card.dart';
import 'package:gp_ecommerce/features/Cart/view/widgets/product_card.dart';
import 'package:gp_ecommerce/features/Cart/view/widgets/promo_code_section.dart';
import 'package:gp_ecommerce/features/payment/view/screens/payment_screen.dart';

// Temporary mock data (replace with bloc/state later) 
const _mockItems = [
  _CartItemData(
    name: 'Titanium X1 Pro',
    price: '\$2,499.00',
    description:
        '32GB RAM / 1TB SSD / 16" Liquid Retina XDR. The pinnacle of portable performance.',
    badges: ['In Stock', 'Free Shipping'],
  ),
  _CartItemData(
    name: 'Acoustic S1000',
    price: '\$549.00',
    description:
        'Reference grade studio monitors with active noise cancellation and spatial awareness.',
    badges: ['In Stock'],
  ),
];

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _navIndex = 3; // Profile tab selected per design

  // Remove item from list
  late List<_CartItemData> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(_mockItems);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = 3048.00;
    final tax = 243.84;

    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.darkbackground,
        elevation: 0,
        title: Text(
          'KINETIC',
          style: TextStyle(
            color: AppColors.text1,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.text1),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.text1),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          //  Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Gallery',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_items.length} OBJECTS SELECTED',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Product List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return ProductCard(
                name: item.name,
                price: item.price,
                description: item.description,
                badges: item.badges,
                onRemove: () {
                  setState(() => _items.removeAt(index));
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 20),
          ),
          const SizedBox(height: 28),

          // Order Summary 
          OrderSummaryCard(
            subtotal: subtotal,
            tax: tax,
            onCheckout: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentScreen()),
              );
            },
          ),
          const SizedBox(height: 24),

          // Promo Code
          PromoCodeSection(
            onApply: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code "$code" applied!')),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: KineticBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ── Simple data class (replace with your model/bloc later) ────────────────────
class _CartItemData {
  final String name;
  final String price;
  final String description;
  final List<String> badges;

  const _CartItemData({
    required this.name,
    required this.price,
    required this.description,
    this.badges = const [],
  });
}