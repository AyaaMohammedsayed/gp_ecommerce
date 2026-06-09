import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/core/constants/app_images.dart';

class ProductDetailsScreen extends StatelessWidget {
  static String routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final String categoryName = 
    ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(
            color: AppColors.logo,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace_sharp,
            size: 32,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
       Container(
  height: 260,
  
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.grey[800],
    image: DecorationImage(
      image: AssetImage(AppImages.transformers),
      fit: BoxFit.cover,
    ),
  ),
),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DHT22 Temp & Humidity",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "\$3.99",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "● IN STOCK — 530 UNITS",
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "OVERVIEW",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Digital temperature and humidity sensor with single-wire interface. ±0.5 °C accuracy.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "TECHNICAL SPECIFICATIONS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSpecsTable(),
                  const SizedBox(height: 30),
                  _buildAddToCartSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecsTable() {
    final specs = {
      "Type": "Digital capacitive",
      "Temp Range": "-40 to +80 °C",
      "Temp Accuracy": "±0.5 °C",
      "Humidity Range": "0 – 100 % RH",
      "Interface": "Single-wire",
      "Supply Voltage": "3.3 – 5.5 V",
      "Sample Rate": "0.5 Hz (2 s interval)",
      "Package": "4-pin DIP",
    };

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: specs.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(color: Colors.white60),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildAddToCartSection() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove, color: Colors.white),
              ),
              const Text(
                "1",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3C5FF),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: Colors.black),
                SizedBox(width: 10),
                Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
