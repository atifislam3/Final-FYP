import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme_colors.dart';

class ReportImageView extends StatelessWidget {
  final String filePath;

  const ReportImageView({super.key, required this.filePath});

  String get _fileName {
    final parts = filePath.split(RegExp(r'[\\/]+'));
    return parts.isNotEmpty ? parts.last : 'Image Report';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = AppThemeColors.brightnessOf(context);
    return Scaffold(
      backgroundColor: AppThemeColors.scaffoldBg(brightness),
      appBar: AppBar(
        backgroundColor: AppThemeColors.backgroundDecoration(brightness).color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: AppThemeColors.primaryText(brightness)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _fileName,
          style: TextStyle(
            color: AppThemeColors.primaryText(brightness),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(
              File(filePath),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Unable to preview this image.',
                    style: TextStyle(
                      color: AppThemeColors.primaryText(brightness),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
