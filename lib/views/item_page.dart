import 'package:flutter/material.dart';
import 'package:handimobil/views/widgets/add_item_widget.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddItemWidget(),
    );
  }
}
