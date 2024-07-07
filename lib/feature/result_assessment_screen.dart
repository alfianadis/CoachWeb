import 'package:coach_web/model/assessment_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class HasilPenilaianScreen extends StatefulWidget {
  @override
  _HasilPenilaianScreenState createState() => _HasilPenilaianScreenState();
}

class _HasilPenilaianScreenState extends State<HasilPenilaianScreen> {
  String _selectedPosition = 'Anchor';
  final List<String> _positions = ['Anchor', 'Pivot', 'Flank', 'Kiper'];
  List<AssessmentModel> _assessments = [];
  final ApiService apiService = ApiService();

  // List<RecentFile> demoRecentFiles = [];
  // List<RecentFile> cadanganFiles = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      List<AssessmentModel> data = await apiService.fetchPlayerData();
      setState(() {
        _assessments = data;
        // _setBestPlayers();
      });
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  double _calculateTotalScore(AssessmentModel player) {
    var criteria = player.aspect.first.criteria;
    var coreFactors = criteria.coreFactor.keys.toList();
    var secondaryFactors = criteria.secondaryFactor.keys.toList();

    double coreScore = 0;
    double secondaryScore = 0;

    for (var factor in coreFactors) {
      double selisih = player.aspect.first.calculateSelisih(factor);
      coreScore += player.aspect.first.getBobotNilai(selisih);
    }
    double ncf = coreScore / coreFactors.length;

    for (var factor in secondaryFactors) {
      double selisih = player.aspect.first.calculateSelisih(factor);
      secondaryScore += player.aspect.first.getBobotNilai(selisih);
    }
    double nsf = secondaryScore / secondaryFactors.length;

    double totalScore = (ncf * 0.6) + (nsf * 0.4);

    return totalScore;
  }

  void _sortPlayersByTotalScore() {
    setState(() {
      _assessments.sort(
          (a, b) => _calculateTotalScore(b).compareTo(_calculateTotalScore(a)));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hasil Penilaian Pemain',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Pilih Posisi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            width: size.width * 0.4, // Atur lebar container
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedPosition,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              items: _positions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          _buildDynamicContainer(size, 'Aspek $_selectedPosition'),
          SizedBox(height: 10),
          Container(
            height: size.height * 0.05,
            width: size.width * 0.45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: cardBackgroundColor,
            ),
            padding: EdgeInsets.only(left: 15, top: 10),
            child: _buildDataTargetTable(),
          ),
          SizedBox(height: 20),
          Container(
            height: size.height * 0.4,
            width: size.width * 0.45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: cardBackgroundColor,
            ),
            padding: EdgeInsets.only(left: 15, top: 10),
            child: _buildDataGapTable(),
          ),
          SizedBox(height: 20),
          Container(
            height: size.height * 0.4,
            width: size.width * 0.45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: cardBackgroundColor,
            ),
            padding: EdgeInsets.only(left: 15, top: 10),
            child: _buildDataBobotTable(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sortPlayersByTotalScore,
            child: Text('Urutkan Berdasarkan Nilai Tertinggi'),
          ),
          SizedBox(height: 20),
          Container(
            height: size.height * 0.4,
            width: size.width * 0.6,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: cardBackgroundColor,
            ),
            padding: EdgeInsets.only(left: 15, top: 10),
            child: _buildDataAkhirTable(),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildDynamicContainer(Size size, String title) {
    return Container(
      height: size.height * 0.4,
      width: size.width * 0.45,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: cardBackgroundColor,
      ),
      padding: EdgeInsets.only(left: 15, top: 10),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: _buildDataTable(title)),
    );
  }

  Widget _buildDataTable(String title) {
    List<AssessmentModel> filteredAssessments = _assessments
        .where((assessment) => assessment.posisi == _selectedPosition)
        .toList();

    if (filteredAssessments.isEmpty) {
      return Center(
          child: Text('Tidak ada data untuk posisi $_selectedPosition'));
    }

    var criteria = filteredAssessments.first.aspect.first.criteria;
    var coreFactors = criteria.coreFactor.keys.toList();
    var secondaryFactors = criteria.secondaryFactor.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: DataTable(
            columns: [
              DataColumn(label: Text('Nama Pemain')),
              DataColumn(label: Text(coreFactors[0])),
              DataColumn(label: Text(coreFactors[1])),
              DataColumn(label: Text(secondaryFactors[0])),
              DataColumn(label: Text(secondaryFactors[1])),
            ],
            rows: filteredAssessments.map((assessment) {
              var aspect = assessment.aspect.first;
              return DataRow(cells: [
                DataCell(Text(assessment.playerName)),
                DataCell(
                    Text(aspect.criteria.coreFactor[coreFactors[0]] ?? '')),
                DataCell(
                    Text(aspect.criteria.coreFactor[coreFactors[1]] ?? '')),
                DataCell(Text(
                    aspect.criteria.secondaryFactor[secondaryFactors[0]] ??
                        '')),
                DataCell(Text(
                    aspect.criteria.secondaryFactor[secondaryFactors[1]] ??
                        '')),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTargetTable() {
    List<AssessmentModel> filteredAssessments = _assessments
        .where((assessment) => assessment.posisi == _selectedPosition)
        .toList();

    if (filteredAssessments.isEmpty) {
      return Center(
          child: Text('Tidak ada data untuk posisi $_selectedPosition'));
    }

    var target = filteredAssessments.first.aspect.first.target;
    var coreFactors = filteredAssessments
        .first.aspect.first.criteria.coreFactor.keys
        .toList();
    var secondaryFactors = filteredAssessments
        .first.aspect.first.criteria.secondaryFactor.keys
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nilai Target',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 90),
          Text(
            target[coreFactors[0]] ?? '',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 85),
          Text(
            target[coreFactors[1]] ?? '',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 140),
          Text(
            target[secondaryFactors[0]] ?? '',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 140),
          Text(
            target[secondaryFactors[1]] ?? '',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDataGapTable() {
    List<AssessmentModel> filteredAssessments = _assessments
        .where((assessment) => assessment.posisi == _selectedPosition)
        .toList();

    if (filteredAssessments.isEmpty) {
      return Center(
          child: Text('Tidak ada data untuk posisi $_selectedPosition'));
    }

    var criteria = filteredAssessments.first.aspect.first.criteria;
    var coreFactors = criteria.coreFactor.keys.toList();
    var secondaryFactors = criteria.secondaryFactor.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Perhitungan Pemetaan GAP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Nama Pemain')),
              DataColumn(label: Text(coreFactors[0])),
              DataColumn(label: Text(coreFactors[1])),
              DataColumn(label: Text(secondaryFactors[0])),
              DataColumn(label: Text(secondaryFactors[1])),
            ],
            rows: filteredAssessments.map((assessment) {
              var aspect = assessment.aspect.first;
              return DataRow(cells: [
                DataCell(Text(assessment.playerName)),
                DataCell(Text((int.parse(aspect.target[coreFactors[0]] ?? '0') -
                        int.parse(
                            aspect.criteria.coreFactor[coreFactors[0]] ?? '0'))
                    .toString())),
                DataCell(Text((int.parse(aspect.target[coreFactors[1]] ?? '0') -
                        int.parse(
                            aspect.criteria.coreFactor[coreFactors[1]] ?? '0'))
                    .toString())),
                DataCell(Text(
                    (int.parse(aspect.target[secondaryFactors[0]] ?? '0') -
                            int.parse(aspect.criteria
                                    .secondaryFactor[secondaryFactors[0]] ??
                                '0'))
                        .toString())),
                DataCell(Text(
                    (int.parse(aspect.target[secondaryFactors[1]] ?? '0') -
                            int.parse(aspect.criteria
                                    .secondaryFactor[secondaryFactors[1]] ??
                                '0'))
                        .toString())),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDataBobotTable() {
    List<AssessmentModel> filteredAssessments = _assessments
        .where((assessment) => assessment.posisi == _selectedPosition)
        .toList();

    if (filteredAssessments.isEmpty) {
      return Center(
          child: Text('Tidak ada data untuk posisi $_selectedPosition'));
    }

    var criteria = filteredAssessments.first.aspect.first.criteria;
    var coreFactors = criteria.coreFactor.keys.toList();
    var secondaryFactors = criteria.secondaryFactor.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pembobotan Nilai GAP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Nama Pemain')),
              DataColumn(label: Text(coreFactors[0])),
              DataColumn(label: Text(coreFactors[1])),
              DataColumn(label: Text(secondaryFactors[0])),
              DataColumn(label: Text(secondaryFactors[1])),
            ],
            rows: filteredAssessments.map((assessment) {
              var aspect = assessment.aspect.first;
              return DataRow(cells: [
                DataCell(Text(assessment.playerName)),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[coreFactors[0]] ?? '0') -
                                int.parse(aspect
                                        .criteria.coreFactor[coreFactors[0]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[coreFactors[1]] ?? '0') -
                                int.parse(aspect
                                        .criteria.coreFactor[coreFactors[1]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[secondaryFactors[0]] ?? '0') -
                                int.parse(aspect.criteria
                                        .secondaryFactor[secondaryFactors[0]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[secondaryFactors[1]] ?? '0') -
                                int.parse(aspect.criteria
                                        .secondaryFactor[secondaryFactors[1]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDataAkhirTable() {
    List<AssessmentModel> filteredAssessments = _assessments
        .where((assessment) => assessment.posisi == _selectedPosition)
        .toList();

    if (filteredAssessments.isEmpty) {
      return Center(
          child: Text('Tidak ada data untuk posisi $_selectedPosition'));
    }

    var criteria = filteredAssessments.first.aspect.first.criteria;
    var coreFactors = criteria.coreFactor.keys.toList();
    var secondaryFactors = criteria.secondaryFactor.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nilai Akhir',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Nama Pemain')),
              DataColumn(label: Text(coreFactors[0])),
              DataColumn(label: Text(coreFactors[1])),
              DataColumn(label: Text(secondaryFactors[0])),
              DataColumn(label: Text(secondaryFactors[1])),
              DataColumn(label: Text('NCF')),
              DataColumn(label: Text('NSF')),
              DataColumn(label: Text('Total')),
            ],
            rows: filteredAssessments.map((assessment) {
              var aspect = assessment.aspect.first;
              double coreScore = 0;
              double secondaryScore = 0;

              for (var factor in coreFactors) {
                double selisih = aspect.calculateSelisih(factor);
                coreScore += aspect.getBobotNilai(selisih);
              }
              double ncf = coreScore / coreFactors.length;

              for (var factor in secondaryFactors) {
                double selisih = aspect.calculateSelisih(factor);
                secondaryScore += aspect.getBobotNilai(selisih);
              }
              double nsf = secondaryScore / secondaryFactors.length;

              double totalScore = (ncf * 0.6) + (nsf * 0.4);

              return DataRow(cells: [
                DataCell(Text(assessment.playerName)),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[coreFactors[0]] ?? '0') -
                                int.parse(aspect
                                        .criteria.coreFactor[coreFactors[0]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[coreFactors[1]] ?? '0') -
                                int.parse(aspect
                                        .criteria.coreFactor[coreFactors[1]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[secondaryFactors[0]] ?? '0') -
                                int.parse(aspect.criteria
                                        .secondaryFactor[secondaryFactors[0]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(aspect
                    .getBobotNilai(
                        (int.parse(aspect.target[secondaryFactors[1]] ?? '0') -
                                int.parse(aspect.criteria
                                        .secondaryFactor[secondaryFactors[1]] ??
                                    '0'))
                            .toDouble())
                    .toString())),
                DataCell(Text(ncf.toStringAsFixed(2))),
                DataCell(Text(nsf.toStringAsFixed(2))),
                DataCell(Text(totalScore.toStringAsFixed(2))),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
