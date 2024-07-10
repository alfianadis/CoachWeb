import 'package:coach_web/model/aspek_model.dart';
import 'package:coach_web/model/kriteria_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:flutter/material.dart';

class EditKriteriaDialog extends StatefulWidget {
  final KriteriaModel kriteria;

  const EditKriteriaDialog({Key? key, required this.kriteria})
      : super(key: key);

  @override
  State<EditKriteriaDialog> createState() => _EditKriteriaDialogState();
}

class _EditKriteriaDialogState extends State<EditKriteriaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameAspekController;

  // variabel
  bool isAspek = false;

  String selectedPosisi = '';
  String selectedAspek = '';
  String selectedTarget = '';
  String selectedTipeKriteria = '';

  final ApiService apiService = ApiService();

  List<String> listPosisi = ['Pivot', 'Anchor', 'Flank', 'Kiper'];
  List<AspekModel> listAspek = [];
  List<String> listTarget = ['1', '2', '3', '4'];
  List<String> listTipeKriteria = ['Core Factor', 'Secondary Factor'];

  @override
  void initState() {
    super.initState();
    _fetchAspeks();
    _initializeFields();
  }

  void _initializeFields() {
    _nameAspekController =
        TextEditingController(text: widget.kriteria.criteria);
    selectedPosisi = widget.kriteria.posisi;
    selectedAspek = widget.kriteria.assessmentAspect;
    selectedTarget = widget.kriteria.target;
    selectedTipeKriteria = widget.kriteria.criteriaType;
  }

  Future<void> _fetchAspeks() async {
    try {
      listAspek = await apiService.getAspeks();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load aspects: $e')),
      );
    }
  }

  void _editKriteria() async {
    if (selectedPosisi.isNotEmpty &&
        selectedAspek.isNotEmpty &&
        _nameAspekController.text.isNotEmpty &&
        selectedTarget.isNotEmpty &&
        selectedTipeKriteria.isNotEmpty) {
      KriteriaModel kriteria = KriteriaModel(
        id: widget.kriteria.id,
        posisi: selectedPosisi,
        assessmentAspect: selectedAspek,
        criteria: _nameAspekController.text,
        target: selectedTarget,
        criteriaType: selectedTipeKriteria,
        createdAt: widget.kriteria.createdAt,
        updatedAt: DateTime.now(),
        v: widget.kriteria.v,
      );

      try {
        bool result = await apiService.updateKriteria(kriteria);

        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kriteria berhasil diubah!'),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mengubah kriteria!'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat mengubah kriteria!'),
          ),
        );
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
    return AlertDialog(
      title: const Text('Edit Kriteria'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Posisi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPosisi.isEmpty ? null : selectedPosisi,
                onChanged: (newValue) {
                  setState(() {
                    selectedPosisi = newValue!;
                  });
                },
                items: listPosisi.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Pilih Posisi',
                ),
                validator: (value) =>
                    value == null ? 'Harap pilih posisi' : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Aspek Penilaian',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedAspek.isEmpty ? null : selectedAspek,
                onChanged: (newValue) {
                  setState(() {
                    selectedAspek = newValue!;
                  });
                },
                items:
                    listAspek.map<DropdownMenuItem<String>>((AspekModel value) {
                  return DropdownMenuItem<String>(
                    value: value.assessmentAspect,
                    child: Text(value.assessmentAspect),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Pilih Aspek',
                ),
                validator: (value) =>
                    value == null ? 'Harap pilih aspek' : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Kriteria',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameAspekController,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "Masukkan Nama Kriteria",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 12,
                      color: AppColors.greySixColor),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Harap masukkan kriteria'
                    : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Target',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedTarget.isEmpty ? null : selectedTarget,
                onChanged: (newValue) {
                  setState(() {
                    selectedTarget = newValue!;
                  });
                },
                items: listTarget.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Pilih Target',
                ),
                validator: (value) =>
                    value == null ? 'Harap pilih target' : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tipe Kriteria',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value:
                    selectedTipeKriteria.isEmpty ? null : selectedTipeKriteria,
                onChanged: (newValue) {
                  setState(() {
                    selectedTipeKriteria = newValue!;
                  });
                },
                items: listTipeKriteria
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Pilih Tipe Kriteria',
                ),
                validator: (value) =>
                    value == null ? 'Harap pilih tipe kriteria' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _editKriteria();
            }
          },
          child: Text('Simpan Perubahan'),
        ),
      ],
    );
  }
}
