import 'package:flutter/material.dart';
import '../../controllers/item_controller.dart';

class EditItemDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final ItemController itemController;

  const EditItemDialog({
    Key? key,
    required this.item,
    required this.itemController,
  }) : super(key: key);

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController itemNameController;
  late TextEditingController brandController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.item['item']);
    brandController = TextEditingController(text: widget.item['brand']);
    priceController =
        TextEditingController(text: widget.item['price'].toString());
  }

  @override
  void dispose() {
    itemNameController.dispose();
    brandController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemNameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await widget.itemController.updateItem(
              id: widget.item['id'],
              item: itemNameController.text.trim(),
              brand: brandController.text.trim(),
              price: priceController.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
