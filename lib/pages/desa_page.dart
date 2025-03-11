import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DesaPage extends StatefulWidget {
  final String districtId;
  final String districtName;

  const DesaPage({super.key, required this.districtId, required this.districtName});

  @override
  _DesaPageState createState() => _DesaPageState();
}

class _DesaPageState extends State<DesaPage> {
  List villages = [];

  @override
  void initState() {
    super.initState();
    fetchVillages();
  }

  Future<void> fetchVillages() async {
    final response = await http.get(
      Uri.parse('https://open-api.my.id/api/wilayah/villages/${widget.districtId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        villages = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desa di ${widget.districtName}')),
      body: villages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: villages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(villages[index]['name']),
                );
              },
            ),
    );
  }
}
