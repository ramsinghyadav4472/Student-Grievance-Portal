import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum ButtonType { primary, secondary, outline, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();

    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(text, style: textStyle),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: buttonChild,
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppConstants.accentColor,
          foregroundColor: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        );
      case ButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppConstants.primaryColor,
          elevation: 0,
          side: const BorderSide(color: AppConstants.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        );
      case ButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppConstants.errorColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.danger:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );
      case ButtonType.outline:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.primaryColor,
        );
    }
  }
}

// Small button variant
class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;

  const SmallButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: type,
      icon: icon,
      isFullWidth: false,
      height: 36,
    );
  }
} 