import 'package:flutter/material.dart';

import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Text('''
Privacy Policy

1. Introduction
Welcome to our Privacy Policy. We respect your privacy and are committed to protecting your personal data.

2. Data Collection
We collect data you provide directly to us, such as when you create or modify your account.

3. Use of Data
We may use the data we collect to provide, maintain, and improve our services.

4. Data Sharing
We do not share your personal data with third parties except as necessary to provide our services.

5. Security
We take reasonable measures to help protect data about you from loss, theft, misuse, and unauthorized access.

6. Changes to Policy
We may change this privacy policy from time to time.
          ''', style: TextStyle(fontSize: 5.sp, height: 1.5)),
      ),
    );
  }
}
