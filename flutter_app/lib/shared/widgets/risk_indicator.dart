import 'package:flutter/material.dart';

class RiskIndicator extends StatelessWidget {
  final double probability; // Value between 0.0 and 1.0
  final String disclaimerText;
  final String titleText;
  final String probabilityLabelText;
  final Map<String, String> riskLabels; // Mapping of 'low', 'moderate', 'elevated'

  const RiskIndicator({
    super.key,
    required this.probability,
    required this.disclaimerText,
    required this.titleText,
    required this.probabilityLabelText,
    required this.riskLabels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final percentage = (probability * 100).toInt();

    // Determine category and visual markers
    String riskLevel;
    Color riskColor;
    IconData riskIcon;
    String accessibilityHint;

    if (probability < 0.40) {
      riskLevel = riskLabels['low'] ?? 'Lower screening indicator';
      riskColor = const Color(0xFF10B981); // Emerald Green
      riskIcon = Icons.check_circle_outline;
      accessibilityHint = "Low risk indicator category. Score is $percentage percent.";
    } else if (probability < 0.70) {
      riskLevel = riskLabels['moderate'] ?? 'Moderate screening indicator';
      riskColor = const Color(0xFFF59E0B); // Amber Orange
      riskIcon = Icons.help_outline;
      accessibilityHint = "Moderate risk indicator category. Score is $percentage percent.";
    } else {
      riskLevel = riskLabels['elevated'] ?? 'Elevated screening indicator';
      riskColor = const Color(0xFFEF4444); // Crimson Red
      riskIcon = Icons.warning_amber_outlined;
      accessibilityHint = "Elevated risk indicator category. Attention recommended. Score is $percentage percent.";
    }

    return Semantics(
      label: "$titleText: $riskLevel",
      value: "$percentage%",
      hint: accessibilityHint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: riskColor,
                    width: 6,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        riskIcon,
                        color: riskColor,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleText,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              riskLevel.toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: riskColor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        probabilityLabelText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: riskColor.withValues(alpha: isDark ? 0.15 : 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: riskColor, width: 1),
                        ),
                        child: Text(
                          "$percentage%",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: isDark ? Colors.white : riskColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Medical disclaimer box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    disclaimerText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.brightness == Brightness.dark
                          ? theme.colorScheme.onErrorContainer
                          : Colors.red[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
