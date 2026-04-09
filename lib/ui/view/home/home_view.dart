import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_button.dart';
import 'product_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<void> productsDetail;

  @override
  void initState() {
    super.initState();
    productsDetail = refreshProducts();
  }

  Future<void> refreshProducts() async {
    final cartVC = Provider.of<CartController>(context, listen: false);
    await cartVC.fetchProducts();
  }

  // ---- Dummy skeleton product for shimmer ----
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
    return Consumer<CartController>(
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
              // -------- Search Bar --------
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 1.h),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.grey.withValues(alpha: .1),
                        blurRadius: 3,
                        spreadRadius: 2,
                        offset: const Offset(0, .3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for products...',
                      hintStyle: TextStyle(color: AppColor.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: AppColor.grey),
                      filled: true,
                      fillColor: AppColor.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 4.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColor.appColor1),
                      ),
                    ),
                  ),
                ),
              ),

              // -------- Product Grid --------
              Expanded(
                child: !isLoading && products.isEmpty
                    ? Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(color: AppColor.grey),
                        ),
                      )
                    : Skeletonizer(
                        enabled: isLoading,
                        effect: ShimmerEffect(
                          baseColor: AppColor.lightGrey.withValues(alpha: 0.3),
                          highlightColor: AppColor.white.withValues(alpha: 0.8),
                        ),
                        child: MasonryGridView.count(
                          padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 14.h),
                          crossAxisCount: 2,
                          mainAxisSpacing: 6.w,
                          crossAxisSpacing: 6.w,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];

                            final String itemName = product['ITEM_NAME'] ?? '';
                            final String price = product['PRICE'] ?? '0';
                            final String stockQty = product['STOCK_QTY'] ?? '0';

                            final bool isEmptyBottle = itemName
                                .toLowerCase()
                                .contains('water bottle');

                            return Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.grey.withValues(alpha: .1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    offset: const Offset(0, .3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: Container(
                                      color: AppColor.lightGrey.withValues(
                                        alpha: 0.2,
                                      ),
                                      height: 22.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(4.w),
                                      child: isLoading
                                          ? const SizedBox()
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  product['IMAGE_URL'] ?? '',
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  Skeletonizer(
                                                    enabled: true,
                                                    effect: ShimmerEffect(
                                                      baseColor: AppColor
                                                          .lightGrey
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      highlightColor: AppColor
                                                          .white
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColor
                                                            .lightGrey
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                    Icons
                                                        .image_not_supported_outlined,
                                                    color: AppColor.grey,
                                                    size: 32,
                                                  ),
                                            ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: AppColor.appDarkColor,
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        0.5.height,
                                        Text(
                                          'Rs. $price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: AppColor.appColor1,
                                          ),
                                        ),
                                        0.5.height,

                                        // Stock
                                        Text(
                                          'Stock: $stockQty',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColor.grey,
                                          ),
                                        ),
                                        1.5.height,
                                        RoundButton(
                                          height: 32,
                                          elevation: 0,
                                          width: double.maxFinite,
                                          buttonColor: isEmptyBottle
                                              ? Colors.green
                                              : AppColor.appColor2,
                                          textColor: isEmptyBottle
                                              ? AppColor.white
                                              : AppColor.black,
                                          title: isEmptyBottle
                                              ? 'Refill'
                                              : 'Order',
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
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
