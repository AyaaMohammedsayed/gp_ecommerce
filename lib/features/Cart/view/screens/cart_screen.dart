import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/app_colors.dart';
import 'package:gp_ecommerce/features/Cart/view/widgets/widgets.dart';
class CartScreen extends StatelessWidget {
  static String routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.secondaryColor,
        title: Text('KINETIC', style: TextStyle(color: AppColors.text1, fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, ), ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.text1),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown, 
                    alignment: Alignment.centerLeft, 
                    child: Text('Your Gallery', 
                    style: TextStyle(color: AppColors.text2, 
                    fontFamily: 'SpaceGrotesk', 
                    fontWeight: FontWeight.w700, 
                    fontSize: 30),))),
              SizedBox(width: 4),
                Text('3 Objects Selected', style: TextStyle(color: AppColors.text3, fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14),)
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24), 
              itemCount: 2,
              itemBuilder: (context, index) => const ProductCard(),
              separatorBuilder: (context, index) => const SizedBox(height: 24), 
            ),
          )
        ],
      ),

    );
  } 
}