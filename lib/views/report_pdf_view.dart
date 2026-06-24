import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/app_theme_colors.dart';

class ReportPdfView extends StatelessWidget {
  final String filePath;

  const ReportPdfView({super.key, required this.filePath});

  String get _fileName {
    final parts = filePath.split(RegExp(r'[\\/]+'));
    return parts.isNotEmpty ? parts.last : 'Report';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = AppThemeColors.brightnessOf(context);
    return Scaffold(
      backgroundColor: AppThemeColors.scaffoldBg(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        child: Container(
          color: AppThemeColors.scaffoldBg(brightness),
          child: SfPdfViewer.file(
            File(filePath),
            onDocumentLoaded: (details) {},
            onDocumentLoadFailed: (details) {
              Get.snackbar(
                'Error',
                'Could not load PDF document.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ),
      ),
    );
  }
}
