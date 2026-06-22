import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Cart/data/cart_item.dart';
import 'package:gp_ecommerce/features/Cart/view_model/cubit.dart';

// Payment Method Enum
enum PaymentMethod { creditCard, paypal, applePay, cash }

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;

  // Local-only address state. The backend has no address field yet, so
  // this isn't persisted — it resets when the screen is rebuilt/app
  // restarts. Swap for a real API call once one exists.
  String _shippingName = 'Julian Thorne';
  String _shippingAddress =
      '882 Tech Plaza, Suite 402\nSilicon Valley, CA 94025\nUnited States';

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
          // Page header
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

          // Shipping Destination
          _SectionHeader(
            icon: Icons.local_shipping_outlined,
            title: 'Shipping Destination',
            actionLabel: 'CHANGE',
            onAction: _showChangeAddressDialog,
          ),
          const SizedBox(height: 12),
          _ShippingCard(
            name: _shippingName,
            address: _shippingAddress,
          ),
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
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded) {
                return _PaymentOrderSummary(items: state.items);
              }
              return const _PaymentOrderSummary(items: []);
            },
          ),
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

          // Security note
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

          // Trust badges
          _TrustBadges(),
          const SizedBox(height: 32),

          // Footer
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

  void _showChangeAddressDialog() {
    final nameController = TextEditingController(text: _shippingName);
    final addressController = TextEditingController(text: _shippingAddress);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: Text(
          'Change Shipping Address',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            color: AppColors.text1,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: AppColors.text1),
              decoration: InputDecoration(
                labelText: 'Full name',
                labelStyle: TextStyle(color: AppColors.text3),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              maxLines: 3,
              style: TextStyle(color: AppColors.text1),
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: AppColors.text3),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _shippingName = nameController.text.trim().isEmpty
                    ? _shippingName
                    : nameController.text.trim();
                _shippingAddress = addressController.text.trim().isEmpty
                    ? _shippingAddress
                    : addressController.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: Text('Save', style: TextStyle(color: AppColors.accentBlue)),
          ),
        ],
      ),
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
  final String name;
  final String address;

  const _ShippingCard({required this.name, required this.address});

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
                  name,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
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
      (PaymentMethod.cash, Icons.payments_outlined, 'CASH ON DELIVERY'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: methods.map((m) {
        final (method, icon, label) = m;
        final isSelected = selected == method;
        return GestureDetector(
          onTap: () => onChanged(method),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.accentBlue : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(icon,
                    size: 24,
                    color:
                        isSelected ? AppColors.accentBlue : AppColors.text3),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? AppColors.accentBlue : AppColors.text3,
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
  final List<CartItemModel> items;

  const _PaymentOrderSummary({required this.items});

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    // Tax isn't returned by the Cart API; showing 0 rather than inventing
    // a percentage. Flagged for backend/teammate alignment.
    const tax = 0.0;
    final total = subtotal + tax;

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

          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.text3,
                ),
              ),
            )
          else
            ...items.map((item) => _OrderItemRow(item: item)),
          const SizedBox(height: 16),
          Divider(color: AppColors.dividerColor, thickness: 1),
          const SizedBox(height: 12),

          _CostRow(
              label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _CostRow(
              label: 'Shipping',
              value: 'Free',
              valueColor: AppColors.accentBlue),
          const SizedBox(height: 8),
          _CostRow(label: 'Tax', value: '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 14),
          Divider(color: AppColors.dividerColor, thickness: 1),
          const SizedBox(height: 12),

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
  final CartItemModel item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 52,
              height: 52,
              child: (item.coverImage != null && item.coverImage!.isNotEmpty)
                  ? Image.network(
                      item.coverImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
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
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
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

  Widget _placeholder() {
    return Container(
      color: AppColors.imagePlaceholder,
      child: Icon(Icons.image_outlined,
          size: 20, color: AppColors.text3.withOpacity(0.4)),
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

// Input formatters
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