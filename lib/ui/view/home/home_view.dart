import 'package:flutter/material.dart';
import 'package:paani/ui/components/custom_appbar.dart';
import '../../../core/extensions/sizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home', icon: Icons.menu, onTap: () {}),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.r),
        child: Column(children: [Center(child: Text('Welcome to PAANI!'))]),
      ),
    );
  }
}
