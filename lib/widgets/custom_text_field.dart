import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          initialValue: initialValue,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? AppConstants.surfaceColor : AppConstants.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// Dropdown field widget
class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemToString;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    required this.itemToString,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemToString(item)),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled ? AppConstants.surfaceColor : AppConstants.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// Search field widget
class SearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onClear;

  const SearchField({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: AppConstants.textSecondaryColor),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppConstants.textSecondaryColor),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: AppConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
} 