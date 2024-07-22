import 'package:coach_web/components/header.dart';
import 'package:coach_web/model/assessment_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class LineupScreen extends StatefulWidget {
  const LineupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LineupScreen> createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen> {
  List<AssessmentModel> _assessments = [];
  final ApiService apiService = ApiService();

  List<RecentFile> demoRecentFiles = [];
  List<RecentFile> cadanganFiles = [];

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
        _setBestPlayers();
      });
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  void _setBestPlayers() {
    List<AssessmentModel> anchorPlayers =
        _getBestPlayersByPosition('Anchor', 1);
    List<AssessmentModel> pivotPlayers = _getBestPlayersByPosition('Pivot', 1);
    List<AssessmentModel> flankPlayers = _getBestPlayersByPosition('Flank', 2);
    List<AssessmentModel> kiperPlayers = _getBestPlayersByPosition('Kiper', 1);

    demoRecentFiles = [
      ...kiperPlayers.map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
      ...anchorPlayers.map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
      ...flankPlayers.map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
      ...pivotPlayers.map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
    ];

    // Select 7 cadangan players with specific composition
    cadanganFiles = [
      ..._getBestPlayersByPosition('Kiper', 1, 1).map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
      ..._getBestPlayersByPosition('Anchor', 2, 1).map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
      ..._getBestPlayersByPosition('Flank', 2, 2).map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
      ..._getBestPlayersByPosition('Pivot', 2, 2).map((player) => RecentFile(
            name: player.playerName,
            posisi: player.posisi,
          )),
    ];
  }

  List<AssessmentModel> _getBestPlayersByPosition(String position, int count,
      [int start = 0]) {
    List<AssessmentModel> filteredPlayers = _assessments
        .where((assessment) => assessment.posisi == position)
        .toList();

    filteredPlayers.sort(
        (a, b) => _calculateTotalScore(b).compareTo(_calculateTotalScore(a)));

    return filteredPlayers.skip(start).take(count).toList();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: 20),
            const Text(
              'Rekomendasi Line Up Pemain',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: PlayerTable(
                    title: "Pemain Inti",
                    demoRecentFiles: demoRecentFiles,
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: PlayerTable(
                    title: "Pemain Cadangan",
                    demoRecentFiles: cadanganFiles,
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                    isScrollable: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerTable extends StatelessWidget {
  final String title;
  final List<RecentFile> demoRecentFiles;
  final double maxHeight;
  final bool isScrollable;

  const PlayerTable({
    super.key,
    required this.title,
    required this.demoRecentFiles,
    required this.maxHeight,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: isScrollable
                  ? SingleChildScrollView(
                      child: buildDataTable(),
                    )
                  : buildDataTable(),
            ),
          ),
        ],
      ),
    );
  }

  DataTable buildDataTable() {
    return DataTable(
      columnSpacing: defaultPadding,
      columns: [
        DataColumn(
          label: Text("Nama Pemain"),
        ),
        DataColumn(
          label: Text("Posisi"),
        ),
      ],
      rows: List.generate(
        demoRecentFiles.length,
        (index) => recentFileDataRow(demoRecentFiles[index]),
      ),
    );
  }

  DataRow recentFileDataRow(RecentFile fileInfo) {
    return DataRow(
      cells: [
        DataCell(Text(fileInfo.name!)),
        DataCell(Text(fileInfo.posisi!)),
      ],
    );
  }
}

class RecentFile {
  final String? name, posisi;

  RecentFile({this.name, this.posisi});
}
