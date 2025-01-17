import 'package:coach_web/components/header.dart';
import 'package:coach_web/config/responsive.dart';
import 'package:coach_web/feature/add_aspek.dart';
import 'package:coach_web/feature/edit_aspek.dart';
import 'package:coach_web/model/aspek_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class AspekScreen extends StatefulWidget {
  const AspekScreen({super.key});

  @override
  State<AspekScreen> createState() => _AspekScreenState();
}

class _AspekScreenState extends State<AspekScreen> {
  final ApiService apiService = ApiService();
  List<AspekModel> aspeks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAspeks();
  }

  void _fetchAspeks() async {
    try {
      List<AspekModel> fetchedAspeks = await apiService.getAspeks();
      setState(() {
        aspeks = fetchedAspeks;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching aspeks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddAspekDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddAspekDialog(),
    );

    if (result == 'success') {
      _fetchAspeks();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'List Aspek',
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
                    onPressed: _showAddAspekDialog,
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Aspek"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 800) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 2 / 1.3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: aspeks.length,
                          itemBuilder: (context, index) {
                            final aspek = aspeks[index];
                            return AspekCard(
                              aspek: aspek,
                              onDelete: _fetchAspeks,
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AspekCard extends StatelessWidget {
  final AspekModel aspek;
  final VoidCallback onDelete;

  const AspekCard({Key? key, required this.aspek, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Sesuaikan padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    aspek.assessmentAspect,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.run_circle, size: 30),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Core Factor',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                ),
                Text(
                  '${aspek.coreFactor}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Secondary Factor',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                ),
                Text(
                  '${aspek.secondaryFactor}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => EditAspekDialog(aspek: aspek),
                    );

                    if (result == 'success') {
                      onDelete();
                    }
                  },
                  child: Container(
                    height: size.height * 0.04,
                    width: size.height * 0.11,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showDeleteConfirmationDialog(context, aspek.id);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chart01,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAspek(BuildContext context, String id) async {
    ApiService apiService = ApiService();
    try {
      bool success = await apiService.deleteAspek(id);
      if (success) {
        print('Aspek deleted successfully');
        onDelete();
      } else {
        print('Failed to delete aspek');
      }
    } catch (e) {
      print('Error: $e');
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
            'Apakah Anda Yakin Untuk Menghapus Aspek Ini?',
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
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
