import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ExcludedCupertinoActivityTypePage extends StatefulWidget {
  final List<CupertinoActivityType>? excludedActivityType;

  const ExcludedCupertinoActivityTypePage({
    super.key,
    this.excludedActivityType,
  });

  @override
  State<StatefulWidget> createState() => _ExcludedActivityTypePageState();
}

class _ExcludedActivityTypePageState
    extends State<ExcludedCupertinoActivityTypePage> {
  final List<String> options = [];
  final List<String> selected = [];

  @override
  void initState() {
    for (final type in CupertinoActivityType.values) {
      options.add(type.value);
    }
    if (widget.excludedActivityType != null &&
        widget.excludedActivityType!.isNotEmpty) {
      for (final type in widget.excludedActivityType!) {
        selected.add(type.value);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluded Activity Type'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final List<CupertinoActivityType> tempSelected = [];
              for (final String type in selected) {
                tempSelected.add(
                  CupertinoActivityType.values
                      .firstWhere((e) => e.value == type),
                );
              }
              Navigator.pop(context, tempSelected);
            },
          ),
        ],
      ),
      body: ListView(
        children: options.map((option) {
          return CheckboxListTile(
            value: selected.contains(option),
            title: Text(option),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  selected.add(option);
                } else {
                  selected.remove(option);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
