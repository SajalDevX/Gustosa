import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/core/inject_dependency/dependencies.dart';
import '../../data/models/countriesModel.dart';
import '../bloc/auth_bloc/bloc.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({Key? key}) : super(key: key);

  @override
  _CountrySelectionScreenState createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final controller = sl<AuthBloc>(); // Accessing the already initialized AuthBloc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your country'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: controller,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];

                    return ListTile(
                      leading: Image.asset(
                        "assets/flags/${country.code.toLowerCase()}.png",
                        width: 32,
                        height: 32,
                      ),
                      title: Text(country.name),
                      trailing: controller.selectedCountry?.code == country.code
                          ? const Icon(Icons.check, color: Colors.blue) // Show a checkmark for the selected country
                          : null,
                      onTap: () {
                        // Update the selected country in the bloc and close the selection screen
                        setState(() {
                          controller.selectedCountry = country;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Country selected: ${controller.selectedCountry?.name}",
                            ),
                          ),
                        );
                        Navigator.pop(context, country);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
