import 'package:coach_web/config/responsive.dart';
import 'package:coach_web/feature/add_kriteria.dart';
import 'package:coach_web/feature/edit_kriteria.dart';
import 'package:coach_web/model/kriteria_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class KriteriaScreen extends StatefulWidget {
  const KriteriaScreen({super.key});

  @override
  State<KriteriaScreen> createState() => _KriteriaScreenState();
}

class _KriteriaScreenState extends State<KriteriaScreen> {
  String _selectedAssessmentAspect = 'Anchor';
  List<String> _assessmentAspects = [];
  ApiService apiService = ApiService();
  List<KriteriaModel> criteria = [];
  List<KriteriaModel> filteredCriteria = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCriteria();
  }

  void _fetchCriteria() async {
    try {
      List<KriteriaModel> fetchedCriteria = await apiService.getKriteria();
      Set<String> aspects =
          fetchedCriteria.map((e) => e.assessmentAspect).toSet();
      setState(() {
        criteria = fetchedCriteria;
        _assessmentAspects = aspects.toList();
        _selectedAssessmentAspect = _assessmentAspects.first;
        filteredCriteria = criteria
            .where((item) => item.assessmentAspect == _selectedAssessmentAspect)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching kriteria: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCriteria(String aspect) {
    setState(() {
      filteredCriteria =
          criteria.where((item) => item.assessmentAspect == aspect).toList();
    });
  }

  Future<void> _showAddKriteriaDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddKriteriaDialog();
      },
    );
    _fetchCriteria(); // Refresh the criteria list after adding a new one
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'List Kriteria',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: _showAddKriteriaDialog,
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Kriteria"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: size.width * 0.4,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedAssessmentAspect,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  items: _assessmentAspects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedAssessmentAspect = newValue;
                        _filterCriteria(newValue);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: filteredCriteria
                          .map((aspek) => KriteriaCard(
                                kriteria: aspek,
                                onDelete: () {
                                  _fetchCriteria(); // Refresh list after deleting
                                },
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  height: size.height * 0.35,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: cardBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Penjelasan Nilai Target',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nilai',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1),
                        Column(
                          children: List.generate(
                            4,
                            (index) {
                              final nilai = index + 1;
                              final deskripsi = [
                                'Kurang',
                                'Cukup',
                                'Baik',
                                'Sangat Baik'
                              ][index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      nilai.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      deskripsi,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KriteriaCard extends StatelessWidget {
  final KriteriaModel kriteria;
  final VoidCallback onDelete;

  const KriteriaCard({Key? key, required this.kriteria, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      width: size.width * 0.18,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kriteria.criteria,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      kriteria.assessmentAspect,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/icons/player.png',
                  width: 30,
                  height: 30,
                ),
              ],
            ),
            SizedBox(
              width: size.width,
              child: const Divider(thickness: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Target',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor),
                ),
                Text(
                  kriteria.target,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Type',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor),
                ),
                Text(
                  kriteria.criteriaType,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            SizedBox(
              width: size.width,
              child: const Divider(thickness: 1),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _showEditKriteriaDialog(context, kriteria);
                  },
                  child: Container(
                    height: size.height * 0.04,
                    width: size.height * 0.11,
                    decoration: BoxDecoration(
                        color: AppColors.greenColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_square,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showDeleteConfirmationDialog(context, kriteria.id);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.chart01),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showEditKriteriaDialog(
      BuildContext context, KriteriaModel kriteria) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditKriteriaDialog(kriteria: kriteria);
      },
    );
    onDelete(); // Refresh list after editing
  }

  void _deleteAspek(BuildContext context, String id) async {
    ApiService apiService = ApiService();
    try {
      bool success = await apiService.deleteKriteria(id);
      if (success) {
        print('Kriteria deleted successfully');
        onDelete(); // Refresh list after deleting
      } else {
        print('Failed to delete kriteria');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, show snackbar, etc.
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          title: const Text(
            'Apakah Anda Yakin Untuk Menghapus Kriteria Ini ?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: 56,
                  decoration: BoxDecoration(
                      color: cardForegroundColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      'Batal',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteAspek(context, id);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: 56,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
