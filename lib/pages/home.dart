import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/pages/addProduct.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> inventory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    final response = await http.get(
      Uri.parse(
        "https://script.google.com/macros/s/AKfycbzdpK4KySkS6QRVc5KbTktCvDZ_d_MYMsPdM41scQFmU5kXBWvleNfUu5bZMTv_0GZBiw/exec",
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        inventory = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load inventory data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Manager")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : inventory.isEmpty
              ? const Center(child: Text("No inventory data available"))
              : ListView.builder(
                itemCount: inventory.length,
                itemBuilder: (context, index) {
                  final item = inventory[index];
                  return ListTile(
                    title: Text(item["Item Name"] ?? "Unknown"),
                    subtitle: Text("Quantity: ${item["Quantity"] ?? "N/A"}"),
                    trailing: Text(
                      item["Quantity"] != null &&
                              int.tryParse(item["Quantity"].toString()) !=
                                  null &&
                              int.parse(item["Quantity"].toString()) < 5
                          ? "⚠ Low Stock"
                          : "✔ Normal",
                      style: TextStyle(
                        color:
                            item["Quantity"] != null &&
                                    int.tryParse(item["Quantity"].toString()) !=
                                        null &&
                                    int.parse(item["Quantity"].toString()) < 5
                                ? Colors.red
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStockScreen()),
              ),
            },
        child: const Icon(Icons.add),
        tooltip: 'Add Stock',
      ),
    );
  }
}
