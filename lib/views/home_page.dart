import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/discovery_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'discovery_details_page.dart';
import '../controllers/authentication.dart';

class HomePage extends StatelessWidget {
  final DiscoveryController discoveryController = Get.find();

  String _getLocalizedStatus(String status) {
    switch (status) {
      case 'in_progress':
        return 'sürmekte';
      case 'pending':
        return 'beklemede';
      case 'completed':
        return 'tamamlandı';
      case 'cancelled':
        return 'iptal edildi';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a FocusNode to detect when the page becomes visible
    FocusManager.instance.primaryFocus?.unfocus();

    // Use onInit in GetX controller instead for initial load
    // discoveryController already handles this in its onInit()

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('İşler'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Sürmekte'),
              Tab(text: 'Beklemede'),
              Tab(text: 'Tamamlandı'),
              Tab(text: 'İptal Edildi'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Get.find<AuthenticationController>().logout();
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => discoveryController.fetchDiscoveries(),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildDiscoveryList('in_progress'),
            _buildDiscoveryList('pending'),
            _buildDiscoveryList('completed'),
            _buildDiscoveryList('cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryList(String status) {
    return Obx(() {
      if (discoveryController.isLoadingList.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredDiscoveries = discoveryController.discoveries
          .where((d) => d['status'] == status)
          .toList();

      if (filteredDiscoveries.isEmpty) {
        return Center(
          child: Text('${_getLocalizedStatus(status)} iş bulunamadı'),
        );
      }

      return RefreshIndicator(
        onRefresh: () => discoveryController.fetchDiscoveries(),
        child: ListView.builder(
          itemCount: filteredDiscoveries.length,
          itemBuilder: (context, index) {
            final discovery = filteredDiscoveries[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            discovery['customer_name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          timeago.format(
                            DateTime.parse(discovery['created_at']),
                            locale: 'tr',
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (discovery['address']?.toString().isNotEmpty ??
                        false) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              discovery['address'].toString(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(discovery['customer_phone']),
                    const SizedBox(height: 4),
                    Text(
                      discovery['discovery'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${discovery['items_count']} Malzeme',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Toplam: ${discovery['total_cost']}₺',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(
                      () => DiscoveryDetailsPage(discoveryId: discovery['id']));
                },
              ),
            );
          },
        ),
      );
    });
  }
}
