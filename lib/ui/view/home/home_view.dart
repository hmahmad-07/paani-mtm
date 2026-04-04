import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_button.dart';
import 'product_detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartVC, child) {
        return Container(
          color: AppColor.white,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
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
              Expanded(
                child: cartVC.products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : MasonryGridView.count(
                        padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 14.h),
                        crossAxisCount: 2,
                        mainAxisSpacing: 6.w,
                        crossAxisSpacing: 6.w,
                        itemCount: cartVC.products.length,
                        itemBuilder: (context, index) {
                          final product = cartVC.products[index];

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
                                Hero(
                                  tag: 'product_${product.id}',
                                  child: ClipRRect(
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
                                      child: Image.asset(
                                        product.imagePath,
                                        fit: BoxFit.contain,
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
                                        product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: AppColor.appDarkColor,
                                          height: 1.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      0.5.height,
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          color: AppColor.appColor1,
                                        ),
                                      ),
                                      1.5.height,
                                      RoundButton(
                                        height: 32,
                                        elevation: 0,
                                        width: double.maxFinite,
                                        buttonColor: AppColor.appColor2,
                                        textColor: AppColor.black,
                                        title: 'Add',
                                        onPress: () {
                                          AppRoutes.push(
                                            ProductDetailView(product: product),
                                          );
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
            ],
          ),
        );
      },
    );
  }
}
