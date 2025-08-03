import 'package:flutter/material.dart';

class SpotSelectionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> spots;

  const SpotSelectionDialog({
    Key? key,
    required this.spots,
  }) : super(key: key);

  @override
  State<SpotSelectionDialog> createState() => _SpotSelectionDialogState();
}

class _SpotSelectionDialogState extends State<SpotSelectionDialog> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text("選擇一個推薦地點",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: widget.spots.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final spot = widget.spots[index];
                  final name = spot['name'] ?? '無名稱';
                  final location = spot['location'] ?? '';
                  final isSelected = selectedIndex == index;

                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE0F2FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(location, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.check_circle, color: Color(0xFF5B7DB1)),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: selectedIndex == null
                  ? null
                  : () {
                final selectedSpot = widget.spots[selectedIndex!];
                final spotName = selectedSpot['name'] ?? '無名稱';
                final placeType = selectedSpot['type'] ?? 'custom';

                print('選擇地點：$spotName, 類型：$placeType');

                Navigator.pop(context, {
                  'spot': spotName,
                  'type': placeType,
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 30),
                backgroundColor: selectedIndex == null
                    ? Colors.grey
                    : const Color(0xFF5B7DB1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("確定", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
