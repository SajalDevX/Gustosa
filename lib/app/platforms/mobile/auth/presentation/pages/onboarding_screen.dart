import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/countriesModel.dart';
import '../components/colored_button.dart';
import '../components/country_code_menu.dart';
import '../components/phone_number_text_box.dart';
import '../bloc/auth_bloc/bloc.dart'; // Import the AuthBloc

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  Country? selectedCountry;
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Access the bloc and set the selected country and phone number
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

  void onBtnClick() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.phoneController.text = phoneController.text;

    // Validate phone number length
    if (phoneController.text.length >= selectedCountry!.minLength &&
        phoneController.text.length <= selectedCountry!.maxLength) {
      print('Phone number is valid');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Phone number is ${authBloc.phoneNumber}',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Phone number must be between ${selectedCountry?.minLength} and ${selectedCountry?.maxLength} digits for ${selectedCountry?.name}.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (selectedCountry == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white70),
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
                        'assets/images/onboarding_img.png',
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
                                horizontal: 20.0, vertical: 20),
                            child: Text(
                              'Welcome to Gustosa',
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
                                        selectedCountry != null
                                            ? Image.asset(
                                          "assets/flags/${selectedCountry!.code.toLowerCase()}.png",
                                          width: 24,
                                          height: 16,
                                          fit: BoxFit.cover,
                                        )
                                            : const Icon(Icons.flag),
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
                                      '+${selectedCountry!.dialCode}',
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
                                onPressed: onBtnClick, text: "Continue"),
                          ),
                          buildDividerWithText('or'),
                        ],
                      ),
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
