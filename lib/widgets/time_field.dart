import 'package:flutter/material.dart';

/// Optional time-of-day picker. `value` is `HH:mm` or null (time unknown).
class TimeField extends StatelessWidget {
  const TimeField({super.key, required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton.icon(
          key: const Key('timeButton'),
          icon: const Icon(Icons.schedule),
          label: Text(value ?? 'Add time (optional)'),
          onPressed: () async {
            final initial = value == null
                ? TimeOfDay.now()
                : TimeOfDay(
                    hour: int.parse(value!.substring(0, 2)),
                    minute: int.parse(value!.substring(3, 5)));
            final picked = await showTimePicker(context: context, initialTime: initial);
            if (picked != null) {
              onChanged('${picked.hour.toString().padLeft(2, '0')}:'
                  '${picked.minute.toString().padLeft(2, '0')}');
            }
          },
        ),
        if (value != null)
          IconButton(
            tooltip: 'Clear time',
            icon: const Icon(Icons.close),
            onPressed: () => onChanged(null),
          ),
      ],
    );
  }
}
