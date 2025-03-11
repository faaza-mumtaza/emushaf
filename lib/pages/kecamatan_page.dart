import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'desa_page.dart';

class KecamatanPage extends StatefulWidget {
  final String regencyId;
  final String regencyName;

  const KecamatanPage({super.key, required this.regencyId, required this.regencyName});

  @override
  _KecamatanPageState createState() => _KecamatanPageState();
}

class _KecamatanPageState extends State<KecamatanPage> {
  List districts = [];

  @override
  void initState() {
    super.initState();
    fetchDistricts();
  }

  Future<void> fetchDistricts() async {
    final response = await http.get(
      Uri.parse('https://open-api.my.id/api/wilayah/districts/${widget.regencyId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        districts = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kecamatan di ${widget.regencyName}')),
      body: districts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(districts[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesaPage(
                          districtId: districts[index]['id'],
                          districtName: districts[index]['name'],
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
