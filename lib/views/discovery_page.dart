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
  final TextEditingController addressController =
      TextEditingController(); // Add the address controller
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
        title: const Text('Yeni Keşif'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Müşteri *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerEmailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Adres',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discoveryTextController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Keşif *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: todoListController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Yapılacaklar Listesi *',
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
                labelText: 'Not',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteToHandiController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Özel Not',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: paymentMethodController,
              decoration: const InputDecoration(
                labelText: 'Ödeme Şekli',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: completionTimeController,
              decoration: const InputDecoration(
                labelText: 'Tamamlanma Süresi (gün) *',
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
                labelText: 'Teklif Geçerlilik Tarihi *',
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
                labelText: 'Hizmet Masrafı',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: transportationCostController,
              decoration: const InputDecoration(
                labelText: 'Ulaşım Masrafı',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: laborCostController,
              decoration: const InputDecoration(
                labelText: 'İşçilik Masrafı',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: extraFeeController,
              decoration: const InputDecoration(
                labelText: 'Ekstra Masraflar',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountRateController,
              decoration: const InputDecoration(
                labelText: 'İndirim Oranı (%)',
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
                labelText: 'İndirim Miktarı',
                border: OutlineInputBorder(),
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
                              'Lütfen zorunlu alanları doldurun.',
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
                            address:
                                addressController.text.trim(), // Add this line
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
                            addressController.clear(); // Add address clearing
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
                      : const Text('Kaydet'),
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
