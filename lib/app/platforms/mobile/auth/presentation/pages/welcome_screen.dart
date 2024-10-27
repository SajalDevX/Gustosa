import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/countriesModel.dart';
import '../components/colored_button.dart';
import '../components/country_code_menu.dart';
import '../components/customProgressIndicator.dart';
import '../components/phone_number_text_box.dart';
import '../bloc/auth_bloc/bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Country? selectedCountry;
  TextEditingController phoneController = TextEditingController();
  bool _isLoading = false; // Local loading indicator control

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      setState(() {
        selectedCountry = authBloc.selectedCountry ?? const Country(
          name: "India",
          flag: "🇮🇳",
          code: "IN",
          dialCode: "91",
          minLength: 10,
          maxLength: 10,
        );
        phoneController.text = authBloc.phoneController.text;
      });
    });
  }

  void onContinueClick() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.phoneController.text = phoneController.text;

    if (phoneController.text.length >= (selectedCountry?.minLength ?? 10) &&
        phoneController.text.length <= (selectedCountry?.maxLength ?? 10)) {
      final phoneNumber = authBloc.phoneNumber;

      authBloc.add(AuthSignInWithPhoneRequested(
        phoneNumber,
        context,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sending OTP to $phoneNumber',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Phone number must be between ${selectedCountry?.minLength ?? 10} and ${selectedCountry?.maxLength ?? 10} digits for ${selectedCountry?.name ?? "India"}.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.48,
                            width: screenWidth,
                            child: Image.asset(
                              'assets/images/app_onboard_img.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(color: Colors.white70),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 16),
                                  child: Text(
                                    'Welcome to Stumato',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                buildDividerWithText('Login or sign up'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final country = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const CountrySelectionScreen(),
                                        ),
                                      );
                                      if (country != null) {
                                        setState(() {
                                          selectedCountry = country;
                                          BlocProvider.of<AuthBloc>(context)
                                              .selectedCountry = country;
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 48,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/flags/${selectedCountry?.code.toLowerCase() ?? 'in'}.png",
                                                width: 24,
                                                height: 16,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_drop_down,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: CustomTextBox(
                                            hint: 'Enter Phone Number',
                                            controller: phoneController,
                                            height: 48,
                                            width: double.infinity,
                                            prefixText:
                                            '+${selectedCountry?.dialCode ?? '91'}',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: ColoredButton(
                                      onPressed: onContinueClick, text: "Continue"),
                                ),
                                buildDividerWithText('or'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.read<AuthBloc>().add(AuthSignInWithGoogleRequested(context));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.white,
                                          shape: const CircleBorder(),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: Image.asset(
                                            'assets/images/google_logo.png',
                                            fit: BoxFit.cover,
                                            height: 36,
                                            width: 36,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.white,
                                          shape: const CircleBorder(),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(0.0),
                                          child: Image.asset(
                                            'assets/images/email_logo.png',
                                            fit: BoxFit.cover,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        Text('By continuing, you agree to our'),
                        Text(
                          'Terms & Conditions and Privacy Policy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) ...[
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              const Center(
                child: CustomProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDividerWithText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              thickness: 1,
              indent: 16,
              endIndent: 8,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              thickness: 1,
              indent: 8,
              endIndent: 16,
            ),
          ),
        ],
      ),
    );
  }
}
