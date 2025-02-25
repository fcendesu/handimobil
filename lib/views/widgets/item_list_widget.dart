import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/item_controller.dart';
import 'edit_item_dialog.dart';

class ItemListWidget extends StatelessWidget {
  final ItemController itemController;

  const ItemListWidget({
    Key? key,
    required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (itemController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (itemController.items.isEmpty) {
          return Center(
            child: Text(
              itemController.searchText.value.isEmpty
                  ? 'Hiçbir malzeme bulunamadı'
                  : 'Hiçbir malzeme bulunamadı "${itemController.searchText.value}"',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: itemController.items.length,
          itemBuilder: (context, index) {
            final item = itemController.items[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(item['item']),
                subtitle:
                    Text('Marka: ${item['brand']}\nFiyat: ${item['price']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditItemDialog(
                            item: item,
                            itemController: itemController,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Malzeme Silme'),
                            content: const Text(
                                'Bu öğeyi silmek istediğinizden emin misiniz?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  itemController.deleteItem(item['id']);
                                },
                                child: const Text('Sil'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
