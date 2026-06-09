// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paani/ui/view/dashboard/dashboard_view.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_appbar.dart';
import '../../components/item_stepper.dart';
import '../cart/cart_view.dart';

class ProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isRefill;

  const ProductDetailView({
    super.key,
    required this.product,
    this.isRefill = false,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with TickerProviderStateMixin {
  late Map<String, dynamic> _selectedProduct;
  late bool _isRefill;
  int _quantity = 1;
  bool _isDescExpanded = false;

  late final AnimationController _descAnimController;
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _priceController;

  late final Animation<double> _descAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _priceScaleAnimation;
  late CartController _cartVC;

  // ── Derived getters ────────────────────────
  String get _itemName => _selectedProduct['ITEM_NAME'] ?? '';
  String get _description => _selectedProduct['DESCRIPTION'] ?? '';
  String get _imageUrl => _selectedProduct['IMAGE_URL'] ?? '';
  double get _unitPrice =>
      double.tryParse(_selectedProduct['PRICE']?.toString() ?? '0') ?? 0.0;
  double get _totalPrice => _unitPrice * _quantity;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.product;
    _isRefill = widget.isRefill;
    _initAnimations();
    _fadeController.forward();
    _slideController.forward();
    // Sync quantity with cart if item already present
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _cartVC = Provider.of<CartController>(context, listen: false);
        final String itemId = _selectedProduct['ITEM_ID']?.toString() ?? '';
        final cartKey = _isRefill ? '${itemId}_refill' : itemId;
        final q = _cartVC.getQuantity(cartKey);
        if (q > 0) setState(() => _quantity = q);
        // keep local quantity in sync when cart changes elsewhere
        _cartVC.addListener(_syncQuantityWithCart);
      } catch (_) {}
    });
  }

  void _syncQuantityWithCart() {
    try {
      final String itemId = _selectedProduct['ITEM_ID']?.toString() ?? '';
      final cartKey = _isRefill ? '${itemId}_refill' : itemId;
      final q = _cartVC.getQuantity(cartKey);
      if (q > 0 && q != _quantity) {
        setState(() => _quantity = q);
      } else if (q == 0 && _quantity != 1) {
        // If removed from cart, reset to 1
        setState(() => _quantity = 1);
      }
    } catch (_) {}
  }

  void _initAnimations() {
    _descAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _descAnimation = CurvedAnimation(
      parent: _descAnimController,
      curve: Curves.easeInOut,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _priceController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
      value: 1.0,
    );
    _priceScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _priceController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _descAnimController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _priceController.dispose();
    try {
      _cartVC.removeListener(_syncQuantityWithCart);
    } catch (_) {}
    super.dispose();
  }

  void _navigateHome() =>
      AppRoutes.pushAndRemoveAll(const DashboardView(initialIndex: 0));

  void _toggleDescription() {
    setState(() => _isDescExpanded = !_isDescExpanded);
    _isDescExpanded
        ? _descAnimController.forward()
        : _descAnimController.reverse();
  }

  void _onIncrement() {
    final cartVC = Provider.of<CartController>(context, listen: false);
    final String itemId = _selectedProduct['ITEM_ID']?.toString() ?? '';
    final cartKey = _isRefill ? '${itemId}_refill' : itemId;
    final inCart = cartVC.getQuantity(cartKey) > 0;
    if (inCart) {
      cartVC.incrementQuantity(cartKey);
      setState(() => _quantity = cartVC.getQuantity(cartKey));
    } else {
      setState(() => _quantity++);
    }
    _pulsePriceAnimation();
  }

  void _onDecrement() {
    final cartVC = Provider.of<CartController>(context, listen: false);
    final String itemId = _selectedProduct['ITEM_ID']?.toString() ?? '';
    final cartKey = _isRefill ? '${itemId}_refill' : itemId;
    final inCart = cartVC.getQuantity(cartKey) > 0;
    if (inCart) {
      cartVC.decrementQuantity(cartKey);
      setState(() => _quantity = cartVC.getQuantity(cartKey));
      _pulsePriceAnimation();
      return;
    }

    if (_quantity > 1) {
      setState(() => _quantity--);
      _pulsePriceAnimation();
    }
  }

  void _pulsePriceAnimation() {
    _priceController.forward(from: 0).then((_) => _priceController.reverse());
  }

  void _onAddToCart() {
    final cartVC = Provider.of<CartController>(context, listen: false);
    final String itemId = _selectedProduct['ITEM_ID']?.toString() ?? '';
    final cartKey = _isRefill ? '${itemId}_refill' : itemId;

    if (cartVC.getQuantity(cartKey) > 0) {
      cartVC.setItemQuantity(
        cartKey,
        _selectedProduct,
        _quantity,
        isRefill: _isRefill,
      );
    } else {
      cartVC.addToCart(
        _selectedProduct,
        isRefill: _isRefill,
        quantity: _quantity,
      );
    }
    AppRoutes.push(
      Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'My Cart'),
        body: const CartView(),
      ),
    );
  }

  void _onProductSelect(Map<String, dynamic> product) {
    if (_selectedProduct['ITEM_ID'] == product['ITEM_ID']) return;

    setState(() {
      _selectedProduct = product;
      _quantity = 1;
      _isDescExpanded = false;
      _isRefill = (product['ITEM_NAME'] ?? '')
          .toString()
          .toLowerCase()
          .contains('water bottle');
    });

    _fadeController.reset();
    _slideController.reset();
    _descAnimController.reset();

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateHome();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Consumer<CartController>(
          builder: (context, _, __) => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _ProductSliverAppBar(
                imageUrl: _imageUrl,
                isRefill: _isRefill,
                onBack: _navigateHome,
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NamePriceCard(
                          itemName: _itemName,
                          totalPrice: _totalPrice,
                          isRefill: _isRefill,
                          priceAnimation: _priceScaleAnimation,
                        ),
                        _QuantityCard(
                          quantity: _quantity,
                          unitPrice: _unitPrice,
                          onIncrement: _onIncrement,
                          onDecrement: _onDecrement,
                        ),
                        if (_description.isNotEmpty)
                          _DescriptionCard(
                            description: _description,
                            isExpanded: _isDescExpanded,
                            animation: _descAnimation,
                            onToggle: _toggleDescription,
                          ),
                        2.height,
                        _RelatedProductsSection(
                          onSelect: _onProductSelect,
                          currentId: _selectedProduct['ITEM_ID'] ?? '',
                        ),
                        SizedBox(height: 14.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomActionBar(
          totalPrice: _totalPrice,
          quantity: _quantity,
          isRefill: _isRefill,
          onBack: _navigateHome,
          onAddToCart: _onAddToCart,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _ProductSliverAppBar
// ─────────────────────────────────────────────

class _ProductSliverAppBar extends StatelessWidget {
  const _ProductSliverAppBar({
    required this.imageUrl,
    required this.isRefill,
    required this.onBack,
  });

  final String imageUrl;
  final bool isRefill;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 46.h,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColor.white,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _HeroBackground(imageUrl: imageUrl, isRefill: isRefill),
        collapseMode: CollapseMode.parallax,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 1,
          color: AppColor.lightGrey.withValues(alpha: 0.3),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: GestureDetector(
          onTap: onBack,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.grey.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.appDarkColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _HeroBackground
// ─────────────────────────────────────────────

class _HeroBackground extends StatelessWidget {
  const _HeroBackground({required this.imageUrl, required this.isRefill});

  final String imageUrl;
  final bool isRefill;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isRefill
                  ? [
                      AppColor.green.withValues(alpha: 0.08),
                      AppColor.appColor2.withValues(alpha: 0.12),
                    ]
                  : [
                      AppColor.appColor2.withValues(alpha: 0.07),
                      AppColor.appColor1.withValues(alpha: 0.04),
                    ],
            ),
          ),
        ),

        // Decorative circle top-right
        Positioned(
          top: -6.h,
          right: -8.w,
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isRefill ? AppColor.green : AppColor.appColor1)
                  .withValues(alpha: 0.06),
            ),
          ),
        ),

        // Decorative circle bottom-left
        Positioned(
          bottom: -4.h,
          left: -6.w,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.appColor2.withValues(alpha: 0.08),
            ),
          ),
        ),

        // Product image
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 5.h),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => Skeletonizer(
              enabled: true,
              effect: ShimmerEffect(
                baseColor: AppColor.lightGrey.withValues(alpha: 0.3),
                highlightColor: AppColor.white.withValues(alpha: 0.8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.lightGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColor.grey.withValues(alpha: 0.5),
                size: 44,
              ),
            ),
          ),
        ),

        // Bottom fade to white
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 8.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.white.withOpacity(0),
                  AppColor.white.withOpacity(1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  _NamePriceCard
// ─────────────────────────────────────────────

class _NamePriceCard extends StatelessWidget {
  const _NamePriceCard({
    required this.itemName,
    required this.totalPrice,
    required this.isRefill,
    required this.priceAnimation,
  });

  final String itemName;
  final double totalPrice;
  final bool isRefill;
  final Animation<double> priceAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: AppColor.lightGrey.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: 0.07),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRefill) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.green.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColor.green.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 4.5.r,
                    color: AppColor.green,
                  ),
                  4.width,
                  Text(
                    'Refill Service',
                    style: TextStyle(
                      fontSize: 3.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.green,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            2.height,
          ],
          Text(
            itemName,
            style: TextStyle(
              fontSize: 6.2.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.appDarkColor,
              height: 1.2,
              letterSpacing: -0.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          1.5.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ScaleTransition(
                scale: priceAnimation,
                child: Text(
                  'Rs. ${totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.appColor1,
                    letterSpacing: -0.5,
                    height: 1,
                  ),
                ),
              ),
              4.width,
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  'PKR',
                  style: TextStyle(
                    fontSize: 3.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _QuantityCard
// ─────────────────────────────────────────────

class _QuantityCard extends StatelessWidget {
  const _QuantityCard({
    required this.quantity,
    required this.unitPrice,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final double unitPrice;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: AppColor.lightGrey.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: 0.07),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUANTITY',
                  style: TextStyle(
                    fontSize: 3.2.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                1.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.appDarkColor,
                        height: 1,
                      ),
                    ),
                    4.width,
                    Text(
                      'item${quantity > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 3.8.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
                0.8.height,
                Text(
                  'Rs. ${unitPrice.toStringAsFixed(0)} each',
                  style: TextStyle(
                    fontSize: 3.2.sp,
                    color: AppColor.appColor1.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.appColor2.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColor.appColor2.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: ItemStepper(
              quantity: quantity,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _DescriptionCard
// ─────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({
    required this.description,
    required this.isExpanded,
    required this.animation,
    required this.onToggle,
  });

  final String description;
  final bool isExpanded;
  final Animation<double> animation;
  final VoidCallback onToggle;

  bool get _hasMore =>
      description.split('\n').length > 3 || description.length > 150;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: AppColor.lightGrey.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: 0.07),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: AppColor.appColor2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 5.5.r,
                  color: AppColor.appColor2,
                ),
              ),
              3.width,
              Text(
                'About this product',
                style: TextStyle(
                  fontSize: 4.8.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.appDarkColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          2.height,
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 3.8.sp,
                    color: AppColor.darkGrey.withValues(alpha: 0.75),
                    height: 1.7,
                    letterSpacing: 0.1,
                  ),
                ),
                if (_hasMore) ...[
                  SizedBox(height: 1.2.h * animation.value),
                  GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.appColor1.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isExpanded ? 'Show less' : 'Read more',
                            style: TextStyle(
                              fontSize: 3.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.appColor1,
                            ),
                          ),
                          3.width,
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.expand_more_rounded,
                              size: 15,
                              color: AppColor.appColor1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _BottomActionBar
// ─────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.totalPrice,
    required this.quantity,
    required this.isRefill,
    required this.onBack,
    required this.onAddToCart,
  });

  final double totalPrice;
  final int quantity;
  final bool isRefill;
  final VoidCallback onBack;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.8.h, 5.w, 4.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(
          top: BorderSide(
            color: AppColor.lightGrey.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: EdgeInsets.all(3.2.r),
              decoration: BoxDecoration(
                color: AppColor.lightGrey.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: AppColor.lightGrey.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.appDarkColor,
                size: 7.r,
              ),
            ),
          ),
          3.width,
          // Gradient CTA button with price pill
          Expanded(
            child: Container(
              height: 6.5.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isRefill
                      ? [AppColor.green, AppColor.green.withValues(alpha: 0.8)]
                      : [
                          AppColor.appColor1,
                          AppColor.appColor1.withValues(alpha: 0.85),
                        ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: (isRefill ? AppColor.green : AppColor.appColor1)
                        .withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAddToCart,
                  borderRadius: BorderRadius.circular(4.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isRefill
                                  ? Icons.refresh_rounded
                                  : Icons.shopping_cart_outlined,
                              color: AppColor.white,
                              size: 5.5.r,
                            ),
                            3.width,
                            Text(
                              isRefill ? 'Schedule Refill' : 'Add to Cart',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 4.5.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Rs. ${totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 3.8.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _RelatedProductsSection
// ─────────────────────────────────────────────

class _RelatedProductsSection extends StatelessWidget {
  const _RelatedProductsSection({
    required this.onSelect,
    required this.currentId,
  });

  final Function(Map<String, dynamic>) onSelect;
  final String currentId;

  @override
  Widget build(BuildContext context) {
    final cartVC = Provider.of<CartController>(context);
    final products = cartVC.productList
        .where((p) => p['ITEM_ID'] != currentId)
        .toList();

    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            'More Products',
            style: TextStyle(
              fontSize: 5.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.appDarkColor,
              letterSpacing: -0.2,
            ),
          ),
        ),
        1.5.height,
        SizedBox(
          height: 22.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final String name = product['ITEM_NAME'] ?? '';
              final String img = product['IMAGE_URL'] ?? '';
              final String price = product['PRICE'] ?? '0';

              return GestureDetector(
                onTap: () => onSelect(product),
                child: Container(
                  width: 38.w,
                  margin: EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 1.h,
                  ),
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.lightGrey.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.grey.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: img,
                            placeholder: (context, url) => Skeletonizer(
                              enabled: true,
                              child: Container(
                                color: AppColor.lightGrey,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_not_supported_outlined),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      1.height,
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 3.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.appDarkColor,
                        ),
                      ),
                      0.5.height,
                      Text(
                        'Rs. $price',
                        style: TextStyle(
                          fontSize: 3.8.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.appColor1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
