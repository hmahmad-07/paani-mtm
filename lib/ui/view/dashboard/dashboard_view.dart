import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../components/app_drawer.dart';
import '../home/home_view.dart';
import '../cart/cart_view.dart';
import '../orders/order_tracking_view.dart';
import '../../components/custom_appbar.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/extensions/routes.dart';
import '../notifications/notifications_view.dart';
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      appBar: CustomAppBar(
        hasLeading: true,
        icon: Iconsax.menu_1_outline,
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        title: _titles[_currentIndex],
        actions: _currentIndex == 0 ? _buildHomeActions() : null,
      ),
      body: Stack(children: [_pages[_currentIndex], _buildFloatingBottomBar()]),
    );
  }

  Widget _buildFloatingBottomBar() {
    return Positioned(
      bottom: 2.h,
      left: 10.w,
      right: 10.w,
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
            _buildNavItem(
              0,
              Iconsax.home_1_outline,
              Iconsax.home_1_bold,
              'Home',
            ),
            _buildNavItem(
              1,
              Iconsax.shopping_cart_outline,
              Iconsax.shopping_cart_bold,
              'Cart',
            ),
            _buildNavItem(2, Iconsax.box_outline, Iconsax.box_bold, 'Orders'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
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
              size: 24,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
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
                              fontSize: 10,
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

  List<Widget> _buildHomeActions() {
    return [
      IconButton(
        icon: Icon(Iconsax.notification_outline, color: AppColor.appColor1),
        onPressed: () {
          AppRoutes.push(const NotificationsView());
        },
      ),
    ];
  }
}
