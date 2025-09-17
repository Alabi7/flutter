import 'package:appd/widgets/home/navbar.dart';
import 'package:flutter/material.dart';
import '../widgets/home/header.dart';
import '../utils/colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const HomeHeader(),
      body: const Center(
        child: Text(
          'Content here (All Notes / Folders)',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      bottomNavigationBar: const NavBar(), // <-- ta navbar isolée
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
}
