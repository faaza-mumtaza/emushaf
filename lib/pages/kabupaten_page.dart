import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'kecamatan_page.dart';

class KabupatenPage extends StatefulWidget {
  final String provinceId;
  final String provinceName;

  const KabupatenPage({super.key, required this.provinceId, required this.provinceName});

  @override
  _KabupatenPageState createState() => _KabupatenPageState();
}

class _KabupatenPageState extends State<KabupatenPage> {
  List regencies = [];

  @override
  void initState() {
    super.initState();
    fetchRegencies();
  }

  Future<void> fetchRegencies() async {
    final response = await http.get(
      Uri.parse('https://open-api.my.id/api/wilayah/regencies/${widget.provinceId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        regencies = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kabupaten/Kota di ${widget.provinceName}')),
      body: regencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: regencies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(regencies[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KecamatanPage(
                          regencyId: regencies[index]['id'],
                          regencyName: regencies[index]['name'],
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
