import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_button.dart';
import 'product_detail_view.dart';

class HomeView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const HomeView({super.key, this.scaffoldKey});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<void> productsDetail;
  late PageController _bannerController;
  Timer? _autoScrollTimer;
  int _currentBanner = 0;

  final List<String> _banners = [
    'assets/banner1.webp',
    'assets/banner2.webp',
    'assets/banner3.webp',
    'assets/banner4.webp',
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    productsDetail = refreshProducts();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % _banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> refreshProducts() async {
    final cartVC = Provider.of<CartController>(context, listen: false);
    await cartVC.fetchProducts();
  }

  Map<String, dynamic> get _dummyProduct => {
    'ITEM_ID': '0',
    'ITEM_NAME': 'Loading product name here',
    'PRICE': '0000',
    'STOCK_QTY': '00',
    'DESCRIPTION': '',
    'IMAGE_URL': '',
  };

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Consumer<CartController>(
        builder: (context, cartVC, child) {
          final isLoading = cartVC.isLoadingProducts;
          final products = isLoading
              ? List.generate(6, (_) => _dummyProduct)
              : cartVC.productList;

          return Container(
            color: AppColor.white,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildBannerCarousel()),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 1.5.h),
                          child: Row(
                            children: [
                              Container(
                                width: 1.w,
                                height: 3.h,
                                decoration: BoxDecoration(
                                  color: AppColor.appColor1,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              2.5.width,
                              Text(
                                'Our Products',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.5.sp,
                                  color: AppColor.appDarkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      !isLoading && products.isEmpty
                          ? SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'No products found',
                                  style: TextStyle(color: AppColor.grey),
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 14.h),
                              sliver: SliverMasonryGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.w,
                                crossAxisSpacing: 4.w,
                                childCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return Skeletonizer(
                                    enabled: isLoading,
                                    effect: ShimmerEffect(
                                      baseColor: AppColor.lightGrey.withValues(
                                        alpha: 0.3,
                                      ),
                                      highlightColor: AppColor.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                    child: _buildProductCard(
                                      product,
                                      isLoading,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColor.white),
      padding: EdgeInsets.fromLTRB(
        4.w,
        MediaQuery.of(context).padding.top + 1.h,
        4.w,
        1.5.h,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.scaffoldKey?.currentState?.openDrawer(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.menu_1_outline,
                color: AppColor.appColor1,
                size: 7.r,
              ),
            ),
          ),
          3.width,
          Expanded(
            child: Text(
              'PAANI.',
              style: TextStyle(
                color: AppColor.appDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 7.sp,
                letterSpacing: 2,
              ),
            ),
          ),
          Icon(
            Iconsax.shopping_cart_outline,
            color: AppColor.appColor1.withValues(alpha: 0.85),
            size: 6.r,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        1.height,
        SizedBox(
          height: 25.h,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    _banners[index],
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        2.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(
                right: index < _banners.length - 1 ? 1.5.w : 0,
              ),
              width: _currentBanner == index ? 6.w : 2.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: _currentBanner == index
                    ? AppColor.appColor1
                    : AppColor.lightGrey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isLoading) {
    final String itemName = product['ITEM_NAME'] ?? '';
    final String price = product['PRICE'] ?? '0';
    final bool isEmptyBottle = itemName.toLowerCase().contains('water bottle');

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: 0.12),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              color: AppColor.appColor1.withValues(alpha: 0.06),
              height: 16.h,
              width: double.infinity,
              child: isLoading
                  ? const SizedBox()
                  : CachedNetworkImage(
                      imageUrl: product['IMAGE_URL'] ?? '',
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColor.grey,
                        size: 8.r,
                      ),
                    ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 1.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 3.8.sp,
                    color: AppColor.appDarkColor,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                0.8.height,
                Text(
                  'Rs. $price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 5.sp,
                    color: AppColor.appColor1,
                  ),
                ),
                1.5.height,
                RoundButton(
                  height: 4.2.h,
                  elevation: 0,
                  buttonRadius: 8,
                  width: double.maxFinite,
                  buttonColor: isEmptyBottle
                      ? const Color(0xFF2E7D32)
                      : AppColor.appColor2,
                  textColor: isEmptyBottle ? AppColor.white : AppColor.black,
                  title: isEmptyBottle ? 'Refill' : 'Order',
                  onPress: () {
                    if (!isLoading) {
                      AppRoutes.push(
                        ProductDetailView(
                          product: product,
                          isRefill: isEmptyBottle,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
