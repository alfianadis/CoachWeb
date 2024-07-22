import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:flutter/material.dart';

class AddPlayerDialog extends StatefulWidget {
  @override
  _AddPlayerDialogState createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  TextEditingController _namePlayerController = TextEditingController();
  TextEditingController _jerseyNumberController = TextEditingController();

  ApiService apiService = ApiService();
  String selectedPosisi = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Pemain'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Pemain',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _namePlayerController,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Masukkan Nama Pemain*",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 12,
                    color: AppColors.greySixColor),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Posisi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedPosisi.isNotEmpty ? selectedPosisi : null,
              items: ['Pivot', 'Anchor', 'Flank', 'Kiper']
                  .map((posisi) => DropdownMenuItem(
                        value: posisi,
                        child: Text(posisi),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPosisi = value!;
                });
              },
              hint: const Text('Pilih Posisi'),
            ),
            const SizedBox(height: 10),
            const Text(
              'No Punggung',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _jerseyNumberController,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Masukkan No Punggung Pemain*",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 12,
                    color: AppColors.greySixColor),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            _addPlayer();
          },
          child: const Text('Tambah Pemain'),
        ),
      ],
    );
  }

  void _addPlayer() {
    if (_namePlayerController.text.isEmpty ||
        _jerseyNumberController.text.isEmpty ||
        selectedPosisi.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Peringatan'),
          content: Text('Harap lengkapi semua informasi yang diperlukan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    apiService
        .addPlayer(
      _namePlayerController.text,
      selectedPosisi,
      _jerseyNumberController.text,
    )
        .then((success) {
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Gagal Menambahkan Pemain'),
            content: Text('Terjadi kesalahan saat menambahkan pemain.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Terjadi kesalahan: $error'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}
