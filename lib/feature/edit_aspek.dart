import 'package:coach_web/model/aspek_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class EditAspekDialog extends StatefulWidget {
  final AspekModel aspek;

  const EditAspekDialog({super.key, required this.aspek});

  @override
  State<EditAspekDialog> createState() => _EditAspekDialogState();
}

class _EditAspekDialogState extends State<EditAspekDialog> {
  late TextEditingController _nameController;
  late TextEditingController _coreFactorController;
  late TextEditingController _secondaryFactorController;

  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.aspek.assessmentAspect);
    _coreFactorController =
        TextEditingController(text: widget.aspek.coreFactor.toString());
    _secondaryFactorController =
        TextEditingController(text: widget.aspek.secondaryFactor.toString());
  }

  void _editAspek() async {
    String name = _nameController.text.trim();
    int coreFactor = int.tryParse(_coreFactorController.text.trim()) ?? 0;
    int secondaryFactor =
        int.tryParse(_secondaryFactorController.text.trim()) ?? 0;

    if (name.isNotEmpty) {
      AspekModel updatedAspek = AspekModel(
        id: widget.aspek.id,
        assessmentAspect: name,
        coreFactor: coreFactor,
        secondaryFactor: secondaryFactor,
        createdAt: widget.aspek.createdAt,
        updatedAt: DateTime.now(),
        v: widget.aspek.v,
      );

      print('Updating aspek: ${updatedAspek.toJson()}');

      bool success = await ApiService().updateAspek(updatedAspek);
      if (success) {
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        print('Update failed');
        // Handle error, show snackbar, etc.
      }
    } else {
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
      title: const Text('Edit Aspek'),
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
                padding: const EdgeInsets.only(left: 25, top: 8),
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
                        padding: const EdgeInsets.only(left: 25, top: 8),
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
                const SizedBox(height: 10),
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
                        padding: const EdgeInsets.only(left: 25, top: 8),
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
                  onTap: _editAspek,
                  child: const Center(
                    child: Text(
                      'Edit Aspek',
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
