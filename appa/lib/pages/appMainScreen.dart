import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appa/pages/appOverviewScreen.dart';
import 'package:appa/pages/appBlockingScreen.dart';
import 'package:appa/utils/constants.dart';
import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int selectedIndex = 0;
  late final List<Widget> page;

  @override
  void initState() {
    page = [
      const AppOverviewScreen(), 
      navBarPage( FontAwesomeIcons.solidStar ),
      const AppBlockingScreen(),
      navBarPage(FontAwesomeIcons.spa),
    ];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconSize: 28,
        currentIndex: selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          color: kPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },

        items: [
          // BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.chartPie))
          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.chartPie ),
            label: "Overview",
          ),

          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.solidStar ),
            label: "Focus",
          ),
          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.recordVinyl ),
            label: "Blocking",
          ),
          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.spa ),
            label: "Explore",
          ),
        ],
      ),

      body: page[selectedIndex],
      
    );
  }

  navBarPage(iconName) {
    return Center(child: Icon(iconName, size: 100, color: kPrimaryColor));
  }
}
