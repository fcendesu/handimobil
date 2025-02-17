import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';
import 'widgets/item_selector_widget.dart';

class DiscoveryPage extends StatelessWidget {
  DiscoveryPage({super.key});

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController discoveryTextController =
      TextEditingController(); // Renamed to avoid conflict
  final TextEditingController todoListController = TextEditingController();
  final TextEditingController noteToCustomerController =
      TextEditingController();
  final TextEditingController noteToHandiController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();

  final DiscoveryController discoveryController =
      Get.put(DiscoveryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Discovery'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Customer Phone *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerEmailController,
              decoration: const InputDecoration(
                labelText: 'Customer Email *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discoveryTextController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Discovery *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: todoListController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Todo List *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ItemSelectorWidget(),
            const SizedBox(height: 16),
            TextField(
              controller: noteToCustomerController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Note to Customer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteToHandiController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Note to Handi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: paymentMethodController,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: discoveryController.isLoading.value
                      ? null
                      : () async {
                          if (customerNameController.text.isEmpty ||
                              customerPhoneController.text.isEmpty ||
                              customerEmailController.text.isEmpty ||
                              discoveryTextController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please fill in all required fields',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          await discoveryController.storeDiscovery(
                            customerName: customerNameController.text.trim(),
                            customerPhone: customerPhoneController.text.trim(),
                            customerEmail: customerEmailController.text.trim(),
                            discovery: discoveryTextController.text.trim(),
                            todoList: todoListController.text.trim(),
                            noteToCustomer:
                                noteToCustomerController.text.trim(),
                            noteToHandi: noteToHandiController.text.trim(),
                            paymentMethod: paymentMethodController.text.trim(),
                          );

                          // Clear the form after successful submission
                          if (!discoveryController.isLoading.value) {
                            customerNameController.clear();
                            customerPhoneController.clear();
                            customerEmailController.clear();
                            discoveryTextController.clear();
                            todoListController.clear();
                            noteToCustomerController.clear();
                            noteToHandiController.clear();
                            paymentMethodController.clear();
                          }
                        },
                  child: discoveryController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Discovery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
