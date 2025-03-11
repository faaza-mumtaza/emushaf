import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'kabupaten_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List provinces = [];

  @override
  void initState() {
    super.initState();
    fetchProvinces();
  }

  Future<void> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('https://open-api.my.id/api/wilayah/provinces'),
    );
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Provinsi')),
      body: provinces.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provinces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provinces[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KabupatenPage(
                          provinceId: provinces[index]['id'],
                          provinceName: provinces[index]['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
