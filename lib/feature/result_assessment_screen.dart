import 'package:coach_web/components/header.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      List<AssessmentModel> data = await apiService.fetchPlayerData();
      // Debugging tambahan untuk mencetak data JSON
      for (var player in data) {
        print('Player JSON: ${player.toJson()}');
      }
      _debugPrintTargets(data); // Tambahkan ini untuk debugging
      setState(() {
        _assessments = data;
      });
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  void _debugPrintTargets(List<AssessmentModel> assessments) {
    for (var assessment in assessments) {
      print('Player: ${assessment.playerName}');
      for (var aspect in assessment.aspect) {
        print('Targets: ${aspect.target}');
        aspect.target.forEach((key, value) {
          print('Target $key: $value');
        });
        aspect.criteria.coreFactor.forEach((key, value) {
          print('Core Factor $key: $value');
        });
        aspect.criteria.secondaryFactor.forEach((key, value) {
          print('Secondary Factor $key: $value');
        });
      }
    }
  }

  double _calculateTotalScore(AssessmentModel player) {
    try {
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
    } catch (e) {
      print('Error calculating total score: $e');
      return 0.0;
    }
  }

  void _sortPlayersByTotalScore() {
    setState(() {
      _assessments.sort(
          (a, b) => _calculateTotalScore(b).compareTo(_calculateTotalScore(a)));
    });
  }

  List<String> _getAllFactors(List<AssessmentModel> assessments) {
    Set<String> factors = {};
    for (var assessment in assessments) {
      for (var aspect in assessment.aspect) {
        factors.addAll(aspect.target.keys);
        factors.addAll(aspect.criteria.coreFactor.keys);
        factors.addAll(aspect.criteria.secondaryFactor.keys);
      }
    }
    return factors.toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header(),
          const SizedBox(height: 20),
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
          _buildResponsiveContainer(_buildDataTargetTable(), size),
          SizedBox(height: 20),
          _buildResponsiveContainer(_buildDataGapTable(), size),
          SizedBox(height: 20),
          _buildResponsiveContainer(_buildDataBobotTable(), size),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sortPlayersByTotalScore,
            child: Text('Urutkan Berdasarkan Nilai Tertinggi'),
          ),
          SizedBox(height: 20),
          _buildResponsiveContainer(_buildDataAkhirTable(), size),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildDynamicContainer(Size size, String title) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: cardBackgroundColor,
      ),
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: _buildDataTable(title),
        ),
      ),
    );
  }

  Widget _buildResponsiveContainer(Widget child, Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: cardBackgroundColor,
        ),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: child,
          ),
        ),
      ),
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

    List<String> allFactors = _getAllFactors(filteredAssessments);

    List<DataColumn> columns = [
      DataColumn(label: Text('Nama Pemain')),
      ...allFactors.map((factor) => DataColumn(label: Text(factor))),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: DataTable(
              columns: columns,
              rows: filteredAssessments.map((assessment) {
                var aspect = assessment.aspect.first;
                return DataRow(cells: [
                  DataCell(Text(assessment.playerName)),
                  ...allFactors.map((factor) {
                    var value = aspect.criteria.coreFactor[factor] ??
                        aspect.criteria.secondaryFactor[factor] ??
                        '0';
                    return DataCell(Text(value));
                  }).toList(),
                ]);
              }).toList(),
            ),
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

    // Dapatkan semua faktor dari target dan kriteria
    List<String> allFactors = _getAllFactors(filteredAssessments);

    // Cetak semua faktor untuk debugging
    print('All Factors: $allFactors');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nilai Target',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 90),
            ...allFactors.map((factor) {
              String? value;
              for (var assessment in filteredAssessments) {
                if (assessment.aspect.first.target.containsKey(factor)) {
                  value = assessment.aspect.first.target[factor];
                  break;
                }
              }
              if (value == null) {
                print('Key not found in target: $factor');
                value = '0';
              } else {
                print('Factor: $factor, Target value: $value');
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ],
        ),
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

    List<String> allFactors = _getAllFactors(filteredAssessments);

    List<DataColumn> columns = [
      DataColumn(label: Text('Nama Pemain')),
      ...allFactors.map((factor) => DataColumn(label: Text(factor))),
    ];

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
          child: IntrinsicWidth(
            child: DataTable(
              columns: columns,
              rows: filteredAssessments.map((assessment) {
                var aspect = assessment.aspect.first;
                return DataRow(cells: [
                  DataCell(Text(assessment.playerName)),
                  ...allFactors.map((factor) => DataCell(Text(
                      (int.parse(aspect.target[factor] ?? '0') -
                              int.parse(aspect.criteria.coreFactor[factor] ??
                                  aspect.criteria.secondaryFactor[factor] ??
                                  '0'))
                          .toString()))),
                ]);
              }).toList(),
            ),
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

    List<String> allFactors = _getAllFactors(filteredAssessments);

    List<DataColumn> columns = [
      DataColumn(label: Text('Nama Pemain')),
      ...allFactors.map((factor) => DataColumn(label: Text(factor))),
    ];

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
          child: IntrinsicWidth(
            child: DataTable(
              columns: columns,
              rows: filteredAssessments.map((assessment) {
                var aspect = assessment.aspect.first;
                return DataRow(cells: [
                  DataCell(Text(assessment.playerName)),
                  ...allFactors.map((factor) => DataCell(Text(aspect
                      .getBobotNilai((int.parse(aspect.target[factor] ?? '0') -
                              int.parse(aspect.criteria.coreFactor[factor] ??
                                  aspect.criteria.secondaryFactor[factor] ??
                                  '0'))
                          .toDouble())
                      .toString()))),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildDataAkhirTable() {
  //   List<AssessmentModel> filteredAssessments = _assessments
  //       .where((assessment) => assessment.posisi == _selectedPosition)
  //       .toList();

  //   if (filteredAssessments.isEmpty) {
  //     return Center(
  //         child: Text('Tidak ada data untuk posisi $_selectedPosition'));
  //   }

  //   List<String> allFactors = _getAllFactors(filteredAssessments);

  //   List<DataColumn> columns = [
  //     DataColumn(label: Text('Nama Pemain')),
  //     ...allFactors.map((factor) => DataColumn(label: Text(factor))),
  //     DataColumn(label: Text('NCF')),
  //     DataColumn(label: Text('NSF')),
  //     DataColumn(label: Text('Total')),
  //   ];

  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           'Nilai Akhir',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 10),
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: DataTable(
  //             columns: columns,
  //             rows: filteredAssessments.map((assessment) {
  //               var aspect = assessment.aspect.first;
  //               double coreScore = 0;
  //               double secondaryScore = 0;

  //               for (var factor in allFactors) {
  //                 double selisih = aspect.calculateSelisih(factor);
  //                 if (aspect.criteria.coreFactor.containsKey(factor)) {
  //                   coreScore += aspect.getBobotNilai(selisih);
  //                 } else if (aspect.criteria.secondaryFactor
  //                     .containsKey(factor)) {
  //                   secondaryScore += aspect.getBobotNilai(selisih);
  //                 }
  //               }
  //               double ncf = coreScore /
  //                   (aspect.criteria.coreFactor.length > 0
  //                       ? aspect.criteria.coreFactor.length
  //                       : 1);
  //               double nsf = secondaryScore /
  //                   (aspect.criteria.secondaryFactor.length > 0
  //                       ? aspect.criteria.secondaryFactor.length
  //                       : 1);

  //               double totalScore = (ncf * 0.6) + (nsf * 0.4);

  //               return DataRow(cells: [
  //                 DataCell(
  //                   Container(
  //                     width: 100, // Set width according to your needs
  //                     child: Text(assessment.playerName, softWrap: true),
  //                   ),
  //                 ),
  //                 ...allFactors.map((factor) {
  //                   return DataCell(
  //                     Container(
  //                       width: 50, // Set width according to your needs
  //                       child: Text(
  //                         aspect
  //                             .getBobotNilai(
  //                               (int.parse(aspect.target[factor] ?? '0') -
  //                                       int.parse(aspect
  //                                               .criteria.coreFactor[factor] ??
  //                                           aspect.criteria
  //                                               .secondaryFactor[factor] ??
  //                                           '0'))
  //                                   .toDouble(),
  //                             )
  //                             .toString(),
  //                         softWrap: true,
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //                 DataCell(
  //                   Container(
  //                     width: 50, // Set width according to your needs
  //                     child: Text(ncf.toStringAsFixed(2), softWrap: true),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   Container(
  //                     width: 50, // Set width according to your needs
  //                     child: Text(nsf.toStringAsFixed(2), softWrap: true),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   Container(
  //                     width: 50, // Set width according to your needs
  //                     child:
  //                         Text(totalScore.toStringAsFixed(2), softWrap: true),
  //                   ),
  //                 ),
  //               ]);
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDataAkhirTable() {
    List<AssessmentModel> filteredAssessments = _assessments
        .where((assessment) => assessment.posisi == _selectedPosition)
        .toList();

    if (filteredAssessments.isEmpty) {
      return Center(
          child: Text('Tidak ada data untuk posisi $_selectedPosition'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Nilai Akhir',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DataTable(
            columns: [
              DataColumn(label: Text('Nama Pemain')),
              DataColumn(label: Text('NCF')),
              DataColumn(label: Text('NSF')),
              DataColumn(label: Text('Total')),
            ],
            rows: filteredAssessments.map((assessment) {
              var aspect = assessment.aspect.first;
              double coreScore = 0;
              double secondaryScore = 0;

              aspect.criteria.coreFactor.forEach((factor, value) {
                double selisih = aspect.calculateSelisih(factor);
                coreScore += aspect.getBobotNilai(selisih);
              });

              aspect.criteria.secondaryFactor.forEach((factor, value) {
                double selisih = aspect.calculateSelisih(factor);
                secondaryScore += aspect.getBobotNilai(selisih);
              });

              double ncf = coreScore /
                  (aspect.criteria.coreFactor.length > 0
                      ? aspect.criteria.coreFactor.length
                      : 1);
              double nsf = secondaryScore /
                  (aspect.criteria.secondaryFactor.length > 0
                      ? aspect.criteria.secondaryFactor.length
                      : 1);

              double totalScore = (ncf * 0.6) + (nsf * 0.4);

              return DataRow(cells: [
                DataCell(
                  Container(
                    width: 150, // Menentukan lebar sesuai kebutuhan
                    child: Text(assessment.playerName, softWrap: true),
                  ),
                ),
                DataCell(
                  Container(
                    width: 50, // Menentukan lebar sesuai kebutuhan
                    child: Text(ncf.toStringAsFixed(2), softWrap: true),
                  ),
                ),
                DataCell(
                  Container(
                    width: 50, // Menentukan lebar sesuai kebutuhan
                    child: Text(nsf.toStringAsFixed(2), softWrap: true),
                  ),
                ),
                DataCell(
                  Container(
                    width: 50, // Menentukan lebar sesuai kebutuhan
                    child: Text(totalScore.toStringAsFixed(2), softWrap: true),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
