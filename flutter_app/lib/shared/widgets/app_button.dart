import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final String? semanticLabel;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final style = type == AppButtonType.outline
        ? theme.outlinedButtonTheme.style
        : theme.elevatedButtonTheme.style;

    Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.outline
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: theme.textTheme.labelLarge?.fontSize,
                ),
              ),
            ],
          );

    Widget button;
    if (type == AppButtonType.outline) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      );
    } else if (type == AppButtonType.secondary) {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style?.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return isDark ? Colors.teal : theme.colorScheme.secondary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return isDark ? Colors.black : theme.colorScheme.onSecondary;
          }),
        ),
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      );
    }

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: semanticLabel ?? text,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: button,
        ),
      ),
    );
  }
}
