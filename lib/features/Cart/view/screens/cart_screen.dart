import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetic/core/constants/app_colors.dart';
import 'package:kinetic/features/Cart/view/widgets/kinetic_bottom_nav.dart';
import 'package:kinetic/features/Cart/view/widgets/order_summary_card.dart';
import 'package:kinetic/features/Cart/view/widgets/product_card.dart';
import 'package:kinetic/features/Cart/view/widgets/promo_code_section.dart';
import 'package:kinetic/features/Cart/view_model/cubit.dart' show CartCubit, CartState, CartError, CartLoading, CartInitial, CartLoaded;
import 'package:kinetic/features/Home/view/screens/home_screen.dart';
import 'package:kinetic/features/Home/view/widgets/custom_drawer.dart';
import 'package:kinetic/features/payment/view/screens/payment_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // No nav item is genuinely "selected" while on the Cart screen since
  // Cart isn't one of the four bottom-nav destinations (per the design,
  // it's reached via the cart icon in the AppBar). -1 = nothing highlighted.
final int _navIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  void _onNavTap(int index) {
    // HomeScreen owns Home/Categories/Favorites/Profile as tabs inside a
    // single IndexedStack (one shared AppBar). Always route there with the
    // right initial tab instead of pushing separate standalone screens —
    // pushing them separately caused stacked/duplicate AppBars.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        onTabSelected: (index) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: index)),
            (route) => false,
          );
        },
      ),
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
            icon: Icon(Icons.refresh, color: AppColors.text1),
            onPressed: () => context.read<CartCubit>().refreshCart(),
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  // Real backend message, not a generic fallback.
                  content: Text(state.message),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return _CartErrorView(
              message: state.message,
              onRetry: () => context.read<CartCubit>().loadCart(),
            );
          }

          // CartItemAdded is a transient signal handled by listener above;
          // by the time we render, loadCart() has already re-emitted CartLoaded.
          final loaded = state is CartLoaded ? state : null;
          if (loaded == null) {
            return const SizedBox.shrink();
          }

          if (loaded.items.isEmpty) {
            return _EmptyCartView(
              onBrowse: () => Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeName,
                (route) => false,
              ),
            );
          }

          final subtotal = loaded.cartTotal;
          // Tax isn't returned by GET /cart; flagged for backend/teammate
          // alignment. Showing 0 rather than a made-up percentage.
          const tax = 0.0;

          return ListView(
            children: [
              // Header
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
                      '${loaded.itemCount} OBJECTS SELECTED',
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
                itemCount: loaded.items.length,
                itemBuilder: (context, index) {
                  final item = loaded.items[index];
                  final isPending =
                      loaded.pendingItemIds.contains(item.cartItemId);
                  return ProductCard(
                    name: item.name,
                    price: '\$${item.effectivePrice.toStringAsFixed(2)}',
                    description: item.isOffer ? 'On offer' : '',
                    badges: item.isOffer ? const ['Offer'] : const [],
                    imagePath: item.coverImage,
                    quantity: item.quantity,
                    isPending: isPending,
                    onIncrement: () => context
                        .read<CartCubit>()
                        .incrementQuantity(item.cartItemId),
                    onDecrement: () => context
                        .read<CartCubit>()
                        .decrementQuantity(item.cartItemId),
                    onRemove: () =>
                        context.read<CartCubit>().removeItem(item.cartItemId),
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
                  // No promo-code endpoint exists yet in the API docs —
                  // flagged for backend/teammate, not faked here.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Promo codes are not supported yet'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
      bottomNavigationBar: KineticBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  final VoidCallback onBrowse;
  const _EmptyCartView({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 64, color: AppColors.text3),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse the catalog and add something you like.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.text3,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Browse Products'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _CartErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}