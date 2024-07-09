import 'package:coach_web/model/statistik_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  String _selectedPosition = 'Anchor';
  final List<String> _positions = ['Anchor', 'Pivot', 'Flank', 'Kiper'];
  String? selectedPemain;
  List<StatistikModel> pemainList = [];
  List<StatistikModel> filteredPemainList = [];
  StatistikModel? selectedPemainStatistik;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPemain();
  }

  Future<void> fetchPemain() async {
    try {
      List<StatistikModel> pemain = await ApiService().fetchPemain();
      setState(() {
        pemainList = pemain;
        filteredPemainList = getPemainByPosisi(_selectedPosition);
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  List<StatistikModel> getPemainByPosisi(String posisi) {
    return pemainList.where((pemain) => pemain.posisi == posisi).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Pemain',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih Posisi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: size.width * 0.3, // Atur lebar container
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedPosition,
              decoration: const InputDecoration(
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
                  filteredPemainList = getPemainByPosisi(_selectedPosition);
                  selectedPemain = null;
                  selectedPemainStatistik = null;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih Pemain',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: size.width * 0.3, // Atur lebar container
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedPemain,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              items: filteredPemainList.map((StatistikModel pemain) {
                return DropdownMenuItem<String>(
                  value: pemain.playerName,
                  child: Text(pemain.playerName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPemain = newValue!;
                  selectedPemainStatistik = filteredPemainList.firstWhere(
                      (pemain) => pemain.playerName == selectedPemain);
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          if (selectedPemainStatistik != null)
            Container(
              height: size.height * 0.85,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: cardBackgroundColor,
              ),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistik',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Nilai',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  buildStatRow(
                      'Jumlah Gol', '${selectedPemainStatistik!.attack.gol}'),
                  buildStatRow('Shooting',
                      '${selectedPemainStatistik!.attack.shooting}'),
                  buildStatRow('Acceleration',
                      '${selectedPemainStatistik!.attack.acceleration}'),
                  buildStatRow(
                      'Speed', '${selectedPemainStatistik!.attack.crossing}'),
                  buildStatRow('Ball Control',
                      '${selectedPemainStatistik!.defence.ballControl}'),
                  buildStatRow('Body Balance',
                      '${selectedPemainStatistik!.defence.bodyBalance}'),
                  buildStatRow('Endurance',
                      '${selectedPemainStatistik!.defence.endurance}'),
                  buildStatRow('Intersep',
                      '${selectedPemainStatistik!.defence.intersep}'),
                  buildStatRow(
                      'Vision', '${selectedPemainStatistik!.taktikal.vision}'),
                  buildStatRow('Passing',
                      '${selectedPemainStatistik!.taktikal.passing}'),
                  buildStatRow('Through Pass',
                      '${selectedPemainStatistik!.taktikal.throughPass}'),
                  buildStatRow(
                      'Save', '${selectedPemainStatistik!.keeper.save}'),
                  buildStatRow(
                      'Refleks', '${selectedPemainStatistik!.keeper.refleks}'),
                  buildStatRow(
                      'Jump', '${selectedPemainStatistik!.keeper.jump}'),
                  buildStatRow('Throwing',
                      '${selectedPemainStatistik!.keeper.throwing}'),
                ],
              ),
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildStatRow(String statName, String statValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            statValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
