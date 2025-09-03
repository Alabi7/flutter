import 'package:app_train/utils/constants.dart';
import 'package:app_train/widgets/myIconButton.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    headerParts(),
                    mySearchBar(),
                  ],
                )
              )
            ],
          ),
        )
      ),
    );
  }
  

  Padding mySearchBar() {
    return Padding(
                    padding: EdgeInsets.symmetric(vertical: 22),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.search_normal),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "search any recipes",
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                        ),

                      ),
                    ),
                  );
  }




  Row headerParts() {
    return Row(children: [
                    const Text(
                      "What are you\ncooking today?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    Myiconbutton(
                      icon: Iconsax.notification, 
                      pressed: () {},
                    )

                  ],);
  }
}