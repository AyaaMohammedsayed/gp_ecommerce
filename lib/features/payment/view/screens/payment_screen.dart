import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp_ecommerce/core/app_colors.dart';

// Mock order item (to be replaced)
class _OrderItem {
  final String name;
  final String subtitle;
  final String price;
  final String? imageUrl;

  const _OrderItem({
    required this.name,
    required this.subtitle,
    required this.price,
    this.imageUrl,
  });
}

const _mockOrderItems = [
  _OrderItem(
    name: 'Kinetic Onyx Headphones',
    subtitle: 'Carbon Black | ANC',
    price: '\$449.00',
  ),
  _OrderItem(
    name: 'Nexus Titanium Phone',
    subtitle: '256GB | Frost Silver',
    price: '\$1,099.00',
  ),
];

// Payment Method Enum 
enum PaymentMethod { creditCard, paypal, applePay }

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;

  final _nameController = TextEditingController(text: 'Julian Thorne');
  final _cardController = TextEditingController(text: '**** **** **** 4421');
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkbackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkbackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'KINETIC',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.text1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.text1),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        children: [
          //  Page header 
          Text(
            'SECURE CHECKOUT',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              letterSpacing: 1.5,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Finalize Order',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 28),

          //  Shipping Destination 
          _SectionHeader(
            icon: Icons.local_shipping_outlined,
            title: 'Shipping Destination',
            actionLabel: 'CHANGE',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          _ShippingCard(),
          const SizedBox(height: 28),

          // Payment Method 
          _SectionHeader(
            icon: Icons.credit_card_outlined,
            title: 'Payment Method',
          ),
          const SizedBox(height: 12),
          _PaymentMethodSelector(
            selected: _selectedMethod,
            onChanged: (m) => setState(() => _selectedMethod = m),
          ),

          // Credit Card Fields (shown only when credit card selected) 
          AnimatedCrossFade(
            firstChild: _CreditCardForm(
              nameController: _nameController,
              cardController: _cardController,
              expiryController: _expiryController,
              cvcController: _cvcController,
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _selectedMethod == PaymentMethod.creditCard
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
          const SizedBox(height: 28),

          // Order Summary 
          _PaymentOrderSummary(items: _mockOrderItems),
          const SizedBox(height: 28),

          // Confirm Button 
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Order',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          //  Security note 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 13, color: AppColors.text3),
              const SizedBox(width: 4),
              Text(
                'SECURE 256-BIT SSL ENCRYPTED PAYMENT',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 0.8,
                  color: AppColors.text3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          //Trust badges
          _TrustBadges(),
          const SizedBox(height: 32),

          //  Footer 
          _Footer(),
        ],
      ),
    );
  }

  void _onConfirm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order confirmed!')),
    );
  }
}

// Sub-widgets 
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.text2),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppColors.text1,
          ),
        ),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.accentBlue,
              ),
            ),
          ),
      ],
    );
  }
}

class _ShippingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Julian Thorne',
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '882 Tech Plaza, Suite 402\nSilicon Valley, CA 94025\nUnited States',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.text3,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.badgeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'DEFAULT',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppColors.text3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  const _PaymentMethodSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final methods = [
      (PaymentMethod.creditCard, Icons.credit_card_outlined, 'CREDIT CARD'),
      (PaymentMethod.paypal, Icons.account_balance_wallet_outlined, 'PAYPAL'),
      (PaymentMethod.applePay, Icons.phone_iphone, 'APPLE PAY'),
    ];

    // FIX 1: crossAxisAlignment.stretch so cards expand to full width
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: methods.map((m) {
        final (method, icon, label) = m;
        final isSelected = selected == method;
        return GestureDetector(
          onTap: () => onChanged(method),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            // FIX 2: explicit full width
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentBlue
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(icon,
                    size: 24,
                    color: isSelected ? AppColors.accentBlue : AppColors.text3),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.accentBlue : AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CreditCardForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController cardController;
  final TextEditingController expiryController;
  final TextEditingController cvcController;

  const _CreditCardForm({
    required this.nameController,
    required this.cardController,
    required this.expiryController,
    required this.cvcController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _FieldLabel('CARDHOLDER NAME'),
        const SizedBox(height: 6),
        _PaymentTextField(controller: nameController, hint: 'Full name'),
        const SizedBox(height: 14),
        _FieldLabel('CARD NUMBER'),
        const SizedBox(height: 6),
        _PaymentTextField(
          controller: cardController,
          hint: '**** **** **** ****',
          keyboardType: TextInputType.number,
          suffixIcon: Icon(Icons.credit_card_outlined,
              size: 20, color: AppColors.text3),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('EXPIRY DATE'),
                  const SizedBox(height: 6),
                  _PaymentTextField(
                    controller: expiryController,
                    hint: 'MM/YY',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryFormatter(),
                      LengthLimitingTextInputFormatter(5),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('CVC / CVV'),
                  const SizedBox(height: 6),
                  _PaymentTextField(
                    controller: cvcController,
                    hint: '***',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        letterSpacing: 1.0,
        color: AppColors.text3,
      ),
    );
  }
}

class _PaymentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _PaymentTextField({
    required this.controller,
    required this.hint,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppColors.text2,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.text3,
        ),
        filled: true,
        fillColor: AppColors.cardColor,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.accentBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _PaymentOrderSummary extends StatelessWidget {
  final List<_OrderItem> items;

  const _PaymentOrderSummary({required this.items});

  @override
  Widget build(BuildContext context) {
    const subtotal = 1548.00;
    const tax = 123.84;
    const total = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 16),

          // Item list
          ...items.map((item) => _OrderItemRow(item: item)),
          const SizedBox(height: 16),
          Divider(color: AppColors.dividerColor, thickness: 1),
          const SizedBox(height: 12),

          // Cost breakdown
          _CostRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _CostRow(label: 'Shipping', value: 'Free',
              valueColor: AppColors.accentBlue),
          const SizedBox(height: 8),
          _CostRow(label: 'Tax', value: '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 14),
          Divider(color: AppColors.dividerColor, thickness: 1),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.text1,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final _OrderItem item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          // Image placeholder (to be swapped with image.network when api is here -menna)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.imagePlaceholder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image_outlined,
                size: 20, color: AppColors.text3.withOpacity(0.4)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.price,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.text1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _CostRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: 'Inter', fontSize: 14, color: AppColors.text3)),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: valueColor ?? AppColors.text2,
          ),
        ),
      ],
    );
  }
}

class _TrustBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const badges = [
      (Icons.verified_user_outlined, 'TRUSTED'),
      (Icons.lock_outline, 'SECURE'),
      (Icons.workspace_premium_outlined, 'WARRANTY'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: badges
          .expand((b) => [
                Column(
                  children: [
                    Icon(b.$1, size: 24, color: AppColors.text3),
                    const SizedBox(height: 4),
                    Text(
                      b.$2,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        letterSpacing: 0.8,
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 36),
              ])
          .toList()
        ..removeLast(),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '© 2024 Kinetic Electronics Global',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.text3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['PRIVACY', 'TERMS', 'SUPPORT'].map((label) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  letterSpacing: 0.5,
                  color: AppColors.text3,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

//  Input formatters 

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}