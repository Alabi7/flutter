import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'custom_header.dart';

class PageTemplate extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final Widget? content;

  const PageTemplate({
    Key? key,
    required this.title,
    required this.icon,
    required this.description,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomHeader(title: title),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppConstants.iconSize,
                color: AppColors.primary,
              ),
              SizedBox(height: AppConstants.defaultPadding),
              Text(
                '$title Page',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: AppConstants.smallPadding),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (content != null) ...[
                SizedBox(height: AppConstants.defaultPadding),
                content!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}