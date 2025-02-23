import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';
import 'widgets/item_selector_widget.dart';
import 'widgets/image_picker_widget.dart';
import '../models/selected_item.dart';

class DiscoveryDetailsPage extends StatefulWidget {
  final int discoveryId;

  const DiscoveryDetailsPage({required this.discoveryId, super.key});

  @override
  State<DiscoveryDetailsPage> createState() => _DiscoveryDetailsPageState();
}

class _DiscoveryDetailsPageState extends State<DiscoveryDetailsPage> {
  final DiscoveryController discoveryController = Get.find();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController discoveryTextController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      discoveryController.fetchDiscoveryDetails(widget.discoveryId).then((_) {
        final discovery = discoveryController.currentDiscovery.value;
        if (discovery != null) {
          customerNameController.text = discovery['customer_name'] ?? '';
          customerPhoneController.text = discovery['customer_phone'] ?? '';
          customerEmailController.text = discovery['customer_email'] ?? '';
          addressController.text = discovery['address'] ?? '';
          discoveryTextController.text = discovery['discovery'] ?? '';
          todoListController.text = discovery['todo_list'] ?? '';
          noteToCustomerController.text = discovery['note_to_customer'] ?? '';
          noteToHandiController.text = discovery['note_to_handi'] ?? '';
          paymentMethodController.text = discovery['payment_method'] ?? '';
          completionTimeController.text =
              discovery['completion_time']?.toString() ?? '';
          offerValidUntilController.text = discovery['offer_valid_until'] ?? '';

          final costs = discovery['costs'] ?? {};
          serviceCostController.text = costs['service_cost']?.toString() ?? '';
          transportationCostController.text =
              costs['transportation_cost']?.toString() ?? '';
          laborCostController.text = costs['labor_cost']?.toString() ?? '';
          extraFeeController.text = costs['extra_fee']?.toString() ?? '';

          final discounts = discovery['discounts'] ?? {};
          discountRateController.text = discounts['rate']?.toString() ?? '';
          discountAmountController.text = discounts['amount']?.toString() ?? '';

          if (discovery['items'] != null) {
            discoveryController.selectedItems.value =
                List<Map<String, dynamic>>.from(discovery['items'])
                    .map((item) => SelectedItem(
                          id: item['id'],
                          name: item['item'],
                          brand: item['brand'],
                          originalPrice: item['base_price']?.toDouble() ?? 0.0,
                          quantity: item['quantity'],
                          customPrice: item['custom_price']?.toDouble(),
                        ))
                    .toList();
          }

          if (discovery['image_urls'] != null) {
            discoveryController.existingImages.value =
                List<String>.from(discovery['image_urls']);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerEmailController.dispose();
    addressController.dispose();
    discoveryTextController.dispose();
    todoListController.dispose();
    noteToCustomerController.dispose();
    noteToHandiController.dispose();
    paymentMethodController.dispose();
    completionTimeController.dispose();
    offerValidUntilController.dispose();
    serviceCostController.dispose();
    transportationCostController.dispose();
    laborCostController.dispose();
    extraFeeController.dispose();
    discountRateController.dispose();
    discountAmountController.dispose();

    discoveryController.selectedItems.clear();
    discoveryController.existingImages.clear();
    discoveryController.selectedImages.clear();
    discoveryController.currentDiscovery.value = null;
    discoveryController.isLoading.value = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşif Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await discoveryController.getShareUrl(widget.discoveryId);
            },
          ),
          Obx(() => TextButton(
                onPressed: discoveryController.isLoading.value
                    ? null
                    : () => _updateDiscovery(),
                child: discoveryController.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Düzenle',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      'Durum: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        final currentStatus = discoveryController
                                .currentDiscovery.value?['status'] ??
                            'pending';
                        return DropdownButton<String>(
                          value: currentStatus,
                          isExpanded: true,
                          items: [
                            ['pending', 'Beklemede'],
                            ['in_progress', 'Sürmekte'],
                            ['completed', 'Tamamlandı'],
                            ['cancelled', 'İptal Edildi']
                          ].map((List<String> status) {
                            return DropdownMenuItem<String>(
                              value: status[0],
                              child: Text(
                                status[1],
                                style: TextStyle(
                                  color: _getStatusColor(status[0]),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              discoveryController.updateDiscoveryStatus(
                                  widget.discoveryId, newValue);
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Müsteri Adı *',
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
                labelText: 'Tamamlanma Süresi (gün)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: offerValidUntilController,
              decoration: const InputDecoration(
                labelText: 'Teklif Geçerlilik Tarihi',
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Toplam Masraf Tutarı',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Toplam Masraf:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() => Text(
                              '${discoveryController.calculateTotalCost().toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: discoveryController.isLoading.value
                      ? null
                      : () => _updateDiscovery(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: discoveryController.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Güncelle',
                          style: TextStyle(fontSize: 16),
                        ),
                )),
          ],
        ),
      ),
    );
  }

  void _updateDiscovery() async {
    if (customerNameController.text.isEmpty ||
        customerPhoneController.text.isEmpty ||
        customerEmailController.text.isEmpty ||
        discoveryTextController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Müşteri adı, telefon numarası ve keşif alanları boş bırakılamaz.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await discoveryController.updateDiscovery(
      widget.discoveryId,
      {
        'customer_name': customerNameController.text.trim(),
        'customer_phone': customerPhoneController.text.trim(),
        'customer_email': customerEmailController.text.trim(),
        'address': addressController.text.trim(),
        'discovery': discoveryTextController.text.trim(),
        'todo_list': todoListController.text.trim(),
        'note_to_customer': noteToCustomerController.text.trim(),
        'note_to_handi': noteToHandiController.text.trim(),
        'payment_method': paymentMethodController.text.trim(),
        'completion_time': completionTimeController.text.trim(),
        'offer_valid_until': offerValidUntilController.text.trim(),
        'service_cost': serviceCostController.text.trim(),
        'transportation_cost': transportationCostController.text.trim(),
        'labor_cost': laborCostController.text.trim(),
        'extra_fee': extraFeeController.text.trim(),
        'discount_rate': discountRateController.text.trim(),
        'discount_amount': discountAmountController.text.trim(),
      },
    );

    if (success) {
      Get.back();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange; // Beklemede
      case 'in_progress':
        return Colors.blue; // Sürmekte
      case 'completed':
        return Colors.green; // Tamamlandı
      case 'cancelled':
        return Colors.red; // İptal Edildi
      default:
        return Colors.grey;
    }
  }
}
