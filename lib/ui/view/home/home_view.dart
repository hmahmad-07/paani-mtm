import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/controllers/cart_controller.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';
import '../../../core/extensions/routes.dart';
import '../../components/custom_button.dart';
import 'order_type_selection_view.dart';
import 'product_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final cartVC = Provider.of<CartController>(context, listen: false);

    if (!cartVC.homeLoaded) {
      _isLoading = true;
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          cartVC.setHomeLoaded();
        }
      });
    } else {
      _isLoading = false;
    }
  }

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
                child: Skeletonizer(
                  enabled: _isLoading,
                  child: cartVC.products.isEmpty && !_isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MasonryGridView.count(
                          padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 14.h),
                          crossAxisCount: 2,
                          mainAxisSpacing: 6.w,
                          crossAxisSpacing: 6.w,
                          itemCount: _isLoading ? 6 : cartVC.products.length,
                          itemBuilder: (context, index) {
                            final product = _isLoading
                                ? cartVC.products[0]
                                : cartVC.products[index];

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
                                    tag: _isLoading
                                        ? 'loading_$index'
                                        : 'product_${product.id}',
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
                                        child: _isLoading
                                            ? const SizedBox()
                                            : Image.asset(
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
                                          'Rs. ${product.price.toStringAsFixed(2)}',
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
                                            if (!_isLoading) {
                                              if (product.id == '2') {
                                                AppRoutes.push(
                                                  OrderTypeSelectionView(
                                                    product: product,
                                                  ),
                                                );
                                              } else {
                                                AppRoutes.push(
                                                  ProductDetailView(
                                                    product: product,
                                                  ),
                                                );
                                              }
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
