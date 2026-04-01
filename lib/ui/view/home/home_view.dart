import 'package:flutter/material.dart';
import 'package:paani/core/constants/app_constants.dart';
import 'package:paani/ui/components/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/auth_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Constants.currentUser;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        actions: [
          IconButton(
            onPressed: () async {
              final authVC = context.read<AuthController>();
              await authVC.logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              child: Text(
                (user?.name.isNotEmpty ?? false)
                    ? user!.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user?.name ?? 'No User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _infoTile(
              icon: Icons.email,
              title: 'Email',
              value: user?.email ?? 'No Email',
            ),
            _infoTile(
              icon: Icons.phone,
              title: 'Phone',
              value: user?.phoneNumber ?? 'No phone',
            ),
            _infoTile(
              icon: Icons.location_on,
              title: 'Address',
              value: user?.address ?? 'No address',
            ),
            _infoTile(
              icon: Icons.info,
              title: 'Status',
              value: user?.status ?? 'No status',
            ),
            _infoTile(
              icon: Icons.delivery_dining,
              title: 'Is Rider',
              value: (user?.isRider ?? false) ? 'Yes' : 'No',
            ),
            _infoTile(
              icon: Icons.vpn_key,
              title: 'Token',
              value: Constants.token,
            ),
          ],
        ),
      ),
    );
  }
}
