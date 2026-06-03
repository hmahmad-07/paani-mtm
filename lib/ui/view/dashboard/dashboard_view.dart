import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../components/app_drawer.dart';
import '../home/home_view.dart';
import '../cart/cart_view.dart';
import '../orders/order_tracking_view.dart';
import '../../components/custom_appbar.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/sizer.dart';

class DashboardView extends StatefulWidget {
  final int initialIndex;
  const DashboardView({super.key, this.initialIndex = 0});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomeView(),
    const CartView(showBottomPadding: true),
    const OrderTrackingView(),
  ];

  final List<String> _titles = ['PAANI Products', 'My Cart', 'My Orders'];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        } else {
          final shouldExit = await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit?'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );

          if (shouldExit == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        appBar: CustomAppBar(
          hasLeading: true,
          icon: Iconsax.menu_1_outline,
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          title: _titles[_currentIndex],
        ),
        body: Stack(
          children: [
            _pages[_currentIndex],
            Positioned(
              bottom: 2.h,
              left: 7.w,
              right: 7.w,
              child: Container(
                height: 8.4.h,
                decoration: BoxDecoration(
                  color: AppColor.appDarkColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    navItems(
                      0,
                      Iconsax.home_2_outline,
                      Iconsax.home_2_bold,
                      'Home',
                    ),
                    navItems(
                      1,
                      Iconsax.shopping_cart_outline,
                      Iconsax.shopping_cart_bold,
                      'Cart',
                    ),
                    navItems(
                      2,
                      Iconsax.box_outline,
                      Iconsax.box_bold,
                      'Orders',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItems(int index, IconData icon, IconData activeIcon, String label) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: AppColor.transparent,
        width: 30.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppColor.white
                  : AppColor.white.withValues(alpha: 0.5),
              size: 8.r,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: isSelected ? 2.h : 0,
              child: isSelected
                  ? SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          0.1.height,
                          Text(
                            label,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 3.2.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
