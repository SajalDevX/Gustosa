import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/components/country_code_text_field.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/components/phone_number_text_field.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/components/sign_in_with_phone_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70.h,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Back Button and Star Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD8DADC)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset('assets/star-icon.svg'),
              ],
            ),
            const SizedBox(height: 26),

            // Login Heading
            Text(
              'Log in to your account',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                letterSpacing: -1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Login Description
            Text(
              'Welcome! Please enter your phone number. We\'ll send you an OTP to verify.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 26),

            // Country Code and Phone Number Fields
            const CountryCodeTextField(),
            const SizedBox(height: 8),
            const PhoneNumberTextField(),
            const Spacer(),

            // Sign-in Button
            const SignInWithPhoneButton(),
          ],
        ),
      ),
    );
  }
}
