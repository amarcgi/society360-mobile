import 'package:flutter/material.dart';

import 'app_text_styles.dart';

class CustomAppBars{
  static AppBar customAppBar({
    required BuildContext context,
    required String title,
    bool showBackButton = true,
    List<Widget>? actions,
    Color? backgroundColor,
    PreferredSizeWidget? bottom
  }) {
    return AppBar(
      title: Text(title, style: AppTextStyles.h1.copyWith(color: Colors.white)), // Force white
      centerTitle: true,
        // 2. This ensures icons (back button, actions) are white
        iconTheme: const IconThemeData(color: Colors.white),
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,
      actions: actions,
        bottom:bottom,
        backgroundColor: backgroundColor ?? const Color(0xFF0D2C54)
    );
  }

}