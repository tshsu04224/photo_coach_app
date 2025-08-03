import 'package:flutter/material.dart';
import 'package:photo_coach/constants/place_type_constants.dart';

class PlaceTypeSelectDialog extends StatefulWidget {
  const PlaceTypeSelectDialog({super.key});

  @override
  State<PlaceTypeSelectDialog> createState() => _PlaceTypeSelectDialogState();
}

class _PlaceTypeSelectDialogState extends State<PlaceTypeSelectDialog> {
  late String selectedLabel;

  @override
  void initState() {
    super.initState();
    selectedLabel = placeTypeOptions.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("選擇你想拍的類型"),
      content: DropdownButton<String>(
        value: selectedLabel,
        isExpanded: true,
        onChanged: (value) => setState(() => selectedLabel = value!),
        items: placeTypeOptions.keys.map((label) {
          return DropdownMenuItem(
            value: label,
            child: Text(label),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("取消"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selectedLabel),
          child: const Text("確定"),
        ),
      ],
    );
  }
}