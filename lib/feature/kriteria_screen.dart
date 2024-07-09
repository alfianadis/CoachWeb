import 'package:coach_web/config/responsive.dart';
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
                    onPressed: () {},
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
                          .map((aspek) => KriteriaCard(kriteria: aspek))
                          .toList(),
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

  const KriteriaCard({Key? key, required this.kriteria}) : super(key: key);

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
                  onTap: () {},
                  child: Container(
                    height: size.height * 0.04,
                    width: size.height * 0.11,
                    decoration: BoxDecoration(
                        color: AppColors.chart01,
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
                  onTap: () {},
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
}
