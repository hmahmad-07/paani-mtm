import 'package:flutter/material.dart';
import '../../../core/extensions/sizer.dart';
import '../../components/custom_appbar.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Terms & Conditions'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: Text('''
Terms & Conditions

1. Acceptance of Terms
By accessing and using this service, you accept and agree to be bound by the terms and provision of this agreement.

2. Provision of Services
We are constantly innovating in order to provide the best possible experience for our users. You acknowledge and agree that the form and nature of our services may change from time to time without prior notice to you.

3. Use of Services
You agree to use the services only for purposes that are permitted by (a) the Terms and (b) any applicable law, regulation or generally accepted practices or guidelines in the relevant jurisdictions.

4. Limitation of Liability
Subject to overall provision in paragraph above, you expressly understand and agree that we shall not be liable to you for any direct, indirect, incidental, special consequential or exemplary damages which may be incurred by you.
          ''', style: TextStyle(fontSize: 5.sp, height: 1.5)),
      ),
    );
  }
}
