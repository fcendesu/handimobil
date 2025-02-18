import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/discovery_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'discovery_details_page.dart';

class HomePage extends StatelessWidget {
  final DiscoveryController discoveryController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Refresh discoveries when page becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      discoveryController.fetchDiscoveries();
    });

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discoveries'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'In Progress'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
          actions: [
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
          child: Text('No ${status.replaceAll('_', ' ')} discoveries'),
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
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        discovery['customer_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.parse(discovery['created_at'])),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
                          '${discovery['items_count']} items',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Total: ${discovery['total_cost']}',
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
