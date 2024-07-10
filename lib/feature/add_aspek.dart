import 'package:coach_web/model/aspek_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class AddAspekDialog extends StatefulWidget {
  const AddAspekDialog({super.key});

  @override
  State<AddAspekDialog> createState() => _AddAspekDialogState();
}

class _AddAspekDialogState extends State<AddAspekDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _coreFactorController = TextEditingController();
  TextEditingController _secondaryFactorController = TextEditingController();

  ApiService _apiService = ApiService();

  void _addAspek() async {
    String name = _nameController.text.trim();
    int coreFactor = int.tryParse(_coreFactorController.text.trim()) ?? 0;
    int secondaryFactor =
        int.tryParse(_secondaryFactorController.text.trim()) ?? 0;

    if (name.isNotEmpty) {
      AspekModel newAspek = AspekModel(
        id: '', // ID akan diisi oleh server, jadi biarkan kosong
        assessmentAspect: name,
        coreFactor: coreFactor,
        secondaryFactor: secondaryFactor,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );

      try {
        // Memanggil metode untuk menambahkan aspek baru
        // ignore: unused_local_variable
        AspekModel addedAspek = await _apiService.createAspekModel(newAspek);

        // Tampilkan pesan sukses atau navigasi ke layar splash success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aspek berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } catch (e) {
        // Tangani error saat gagal menambahkan aspek
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan aspek: $e')),
        );
      }
    } else {
      // Tampilkan pesan jika input tidak valid
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text('Tambah Aspek'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aspek Penilaian',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: size.height * 0.06,
              width: size.width * 0.17,
              decoration: BoxDecoration(
                color: AppColors.greenSecobdColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 20),
                child: Center(
                  child: TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukkan Aspek*",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                          color: AppColors.greySixColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Core Factor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.08,
                      decoration: BoxDecoration(
                        color: AppColors.greenSecobdColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 20),
                        child: TextFormField(
                          controller: _coreFactorController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                                color: AppColors.greySixColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Secondary Factor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.08,
                      decoration: BoxDecoration(
                        color: AppColors.greenSecobdColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 20),
                        child: TextFormField(
                          controller: _secondaryFactorController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                                color: AppColors.greySixColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                height: size.height * 0.06,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: cardForegroundColor,
                ),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap:
                      _addAspek, // Panggil method _addAspek saat tombol ditekan
                  child: const Center(
                    child: Text(
                      'Tambah Aspek',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.whiteTextColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
      ],
    );
  }
}
