import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Add this import at the top
import '../controllers/discovery_controller.dart';
import 'widgets/item_selector_widget.dart';
import 'widgets/image_picker_widget.dart';

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

  final TextEditingController completionTimeController =
      TextEditingController();
  final TextEditingController offerValidUntilController =
      TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();
  final TextEditingController transportationCostController =
      TextEditingController();
  final TextEditingController laborCostController = TextEditingController();
  final TextEditingController extraFeeController = TextEditingController();
  final TextEditingController discountRateController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();

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
            ImagePickerWidget(discoveryController: discoveryController),
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
            const SizedBox(height: 16),
            TextField(
              controller: completionTimeController,
              decoration: const InputDecoration(
                labelText: 'Completion Time (days) *',
                helperText: 'Enter number of days needed to complete the work',
                border: OutlineInputBorder(),
                suffixText: 'days',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: offerValidUntilController,
              decoration: const InputDecoration(
                labelText: 'Offer Valid Until',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  offerValidUntilController.text =
                      picked.toIso8601String().split('T')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: serviceCostController,
              decoration: const InputDecoration(
                labelText: 'Service Cost',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: transportationCostController,
              decoration: const InputDecoration(
                labelText: 'Transportation Cost',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: laborCostController,
              decoration: const InputDecoration(
                labelText: 'Labor Cost',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: extraFeeController,
              decoration: const InputDecoration(
                labelText: 'Extra Fee',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountRateController,
              decoration: const InputDecoration(
                labelText: 'Discount Rate (%)',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountAmountController,
              decoration: const InputDecoration(
                labelText: 'Discount Amount',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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

                          final success =
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
                            completionTime:
                                completionTimeController.text.trim(),
                            offerValidUntil:
                                offerValidUntilController.text.trim(),
                            serviceCost: serviceCostController.text.trim(),
                            transportationCost:
                                transportationCostController.text.trim(),
                            laborCost: laborCostController.text.trim(),
                            extraFee: extraFeeController.text.trim(),
                            discountRate: discountRateController.text.trim(),
                            discountAmount:
                                discountAmountController.text.trim(),
                          );

                          // Clear the form after successful submission
                          if (success) {
                            customerNameController.clear();
                            customerPhoneController.clear();
                            customerEmailController.clear();
                            discoveryTextController.clear();
                            todoListController.clear();
                            noteToCustomerController.clear();
                            noteToHandiController.clear();
                            paymentMethodController.clear();
                            completionTimeController.clear();
                            offerValidUntilController.clear();
                            serviceCostController.clear();
                            transportationCostController.clear();
                            laborCostController.clear();
                            extraFeeController.clear();
                            discountRateController.clear();
                            discountAmountController.clear();
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
