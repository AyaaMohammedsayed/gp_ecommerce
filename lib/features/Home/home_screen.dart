import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubit/home_cubit.dart';
import '../../core/app_colors.dart';
import '../../core/token_storage.dart';
import 'widgets/custom_drawer.dart';
import '../Cart/view/screens/screen.dart';
import '../Categories/view/screens/screen.dart';
import '../Favorites/view/screens/screen.dart';
import '../profile/view/screens/screen.dart';
import '../Auth/view/screens/screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const CategoriesScreen(),
          const FavoritesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── HOME TAB ───────────────────────────────────────────────
  Widget _buildHomeTab() {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading || state is HomeInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is HomeError) {
                  return _buildErrorState(state.message);
                } else if (state is HomeLoaded) {
                  return _buildHomeContent(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── APP BAR ────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          // Menu
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: Icon(Icons.menu, color: Colors.white, size: 24.w),
            ),
          ),
          const Spacer(),
          // Logo
          Text(
            'KINETIC',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          // Cart
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24.w),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(Icons.search, color: AppColors.textLight, size: 22.w),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              onChanged: (v) => context.read<HomeCubit>().searchProducts(v),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Explore our engineered components...',
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.textLight,
                  fontSize: 13.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          Icon(Icons.mic_none_rounded, color: AppColors.textLight, size: 22.w),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }

  // ─── HERO SECTION ───────────────────────────────────────────
  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.h),
        // Subtitle label
        Text(
          'NEW MODULES',
          style: GoogleFonts.poppins(
            color: AppColors.textLight,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8.h),
        // Main title
        Text(
          'EMBEDDED\nCOMPONENTS',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16.h),
        // Description
        Text(
          'Explore a wide range of microcontrollers,\nsensors, ICs, Arduino boards, transistors,\nLEDs, and transformers for your\nelectronics projects.',
          style: GoogleFonts.poppins(
            color: AppColors.textLight,
            fontSize: 13.sp,
            height: 1.7,
          ),
        ),
        SizedBox(height: 24.h),
        // CTA Button
        GestureDetector(
          onTap: () => setState(() => _currentIndex = 1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Text(
              'DISCOVER NOW',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── SECTION HEADER ─────────────────────────────────────────
  Widget _buildSectionHeader(String title, {String? trailing, VoidCallback? onTrailingTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing,
              style: GoogleFonts.poppins(
                color: AppColors.textLight,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }

  // ─── CATEGORIES ROW ─────────────────────────────────────────
  Widget _buildCategoriesRow(HomeLoaded state) {
    return SizedBox(
      height: 88.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final cat = state.categories[index];
          final isSelected = state.selectedCategory == cat.name;
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                context.read<HomeCubit>().loadAllProducts();
              } else {
                context.read<HomeCubit>().selectCategory(cat.name);
              }
            },
            child: Container(
              width: 88.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: isSelected
                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.6), width: 1.5)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(cat.name),
                    color: isSelected ? AppColors.primary : Colors.white70,
                    size: 26.w,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    cat.name.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: isSelected ? AppColors.primary : Colors.white70,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── PRODUCT CARD (tall image card with overlaid text) ──────
  Widget _buildProductCard(dynamic product, {double? height}) {
    // Static descriptions for visual design per the Home.png reference
    final String subtitle = _getProductSubtitle(product.name);

    return Container(
      height: height ?? 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Product image
          CachedNetworkImage(
            imageUrl: product.coverImage,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppColors.surface,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.surface,
              child: Icon(Icons.developer_board, color: AppColors.textLight, size: 48.w),
            ),
          ),
          // Gradient overlay at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.85),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Text overlay
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Price badge top-right
          if (product.isOffer && product.discountedPrice != null)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'EGP ${product.discountedPrice!.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── MAIN SCROLLABLE CONTENT ────────────────────────────────
  Widget _buildHomeContent(HomeLoaded state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          _buildSearchBar(),

          // Hero
          _buildHeroSection(),

          SizedBox(height: 48.h),

          // Categories
          _buildSectionHeader('Curated Categories'),
          SizedBox(height: 16.h),
          _buildCategoriesRow(state),

          SizedBox(height: 36.h),

          // Products
          _buildSectionHeader(
            'Engineering Selects',
            trailing: 'VIEW ALL',
            onTrailingTap: () => setState(() => _currentIndex = 1),
          ),
          SizedBox(height: 16.h),

          // Product cards list — tall cards matching Home.png
          if (state.products.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.products.length > 6 ? 6 : state.products.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  // Product details navigation placeholder
                },
                child: _buildProductCard(state.products[i]),
              ),
            )
          else
            _buildEmptyProducts(),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  // ─── EMPTY PRODUCTS ─────────────────────────────────────────
  Widget _buildEmptyProducts() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, color: AppColors.textLight, size: 40.w),
            SizedBox(height: 12.h),
            Text(
              'No products found',
              style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ERROR STATE ────────────────────────────────────────────
  // Renders a custom view based on the user's login status.
  // If the user is in Guest Mode (unauthenticated), it displays a friendly onboarding/welcome panel
  // prompting them to sign in. If they are logged in but have network issues, it renders a standard connection error view.
  Widget _buildErrorState(String message) {
    final isGuest = !TokenStorage().hasToken;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGuest ? Icons.account_circle_outlined : Icons.cloud_off_rounded,
              color: AppColors.textLight,
              size: 64.w,
            ),
            SizedBox(height: 20.h),
            Text(
              isGuest ? 'Welcome to Kinetic' : 'Connection Error',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isGuest
                  ? 'Please sign in to browse our high-performance electronic components.'
                  : message,
              style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                if (isGuest) {
                  // Navigate to the authentication screen to let the user login/register
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                } else {
                  // Trigger cubit to reload catalog data on network retry
                  context.read<HomeCubit>().loadHomeData();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Text(
                  isGuest ? 'SIGN IN' : 'TRY AGAIN',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM NAV BAR ─────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceVariant.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'HOME', 0),
              _buildNavItem(Icons.grid_view_rounded, 'CATEGORIES', 1),
              _buildNavItem(Icons.favorite_rounded, 'FAVORITES', 2),
              _buildNavItem(Icons.person_rounded, 'PROFILE', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textLight,
              size: 24.w,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isActive ? AppColors.primary : AppColors.textLight,
                fontSize: 9.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ────────────────────────────────────────────────
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'arduino':
        return Icons.developer_board;
      case 'sensors':
      case 'sensor':
        return Icons.sensors;
      case 'ics':
      case 'ic':
        return Icons.memory;
      case 'microcontrollers':
      case 'microcontroller':
        return Icons.developer_board;
      case 'led':
      case 'leds':
        return Icons.lightbulb_outline;
      case 'resistor':
      case 'resistors':
        return Icons.electric_bolt;
      case 'transformer':
      case 'transformers':
        return Icons.power;
      case 'transistor':
      case 'transistors':
        return Icons.settings_input_component;
      case '3d printer':
      case '3d printed product':
        return Icons.print;
      case 'cables':
      case 'cable':
      case 'wire':
      case 'wires':
        return Icons.cable;
      case 'battery':
      case 'batteries':
        return Icons.battery_full;
      case 'motor':
      case 'motors':
        return Icons.rotate_right;
      case 'display':
      case 'displays':
      case 'screen':
        return Icons.monitor;
      case 'tools':
      case 'tool':
        return Icons.build;
      default:
        return Icons.category;
    }
  }

  String _getProductSubtitle(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('ic') || lower.contains('amp') || lower.contains('timer')) {
      return 'Op-amps, 555 timers, logic gates, and shift registers — the signal chain.';
    } else if (lower.contains('sensor') || lower.contains('imu') || lower.contains('temperature')) {
      return 'Temperature, IMU, proximity — sense everything.';
    } else if (lower.contains('arduino') || lower.contains('board')) {
      return 'Development boards for rapid prototyping.';
    } else if (lower.contains('led') || lower.contains('light')) {
      return 'Indicators, displays, and illumination modules.';
    } else if (lower.contains('resistor')) {
      return 'Precision resistors for every circuit need.';
    } else if (lower.contains('capacitor')) {
      return 'Ceramic, electrolytic, and film capacitors.';
    } else if (lower.contains('transistor')) {
      return 'BJT, MOSFET, and IGBT power transistors.';
    } else if (lower.contains('wire') || lower.contains('cable') || lower.contains('connector')) {
      return 'Connectors, cables, and wiring solutions.';
    } else if (lower.contains('motor') || lower.contains('servo')) {
      return 'DC motors, servos, and stepper drivers.';
    } else if (lower.contains('relay')) {
      return 'Switching relays for high-power control.';
    } else {
      return 'Quality electronic components for your projects.';
    }
  }
}
