import 'package:coach_web/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:coach_web/components/header.dart';
import 'package:coach_web/model/emotional_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/constant.dart';

import 'add_emosional.dart';

class EmotionalScreen extends StatefulWidget {
  const EmotionalScreen({super.key});

  @override
  State<EmotionalScreen> createState() => _EmotionalScreenState();
}

class _EmotionalScreenState extends State<EmotionalScreen> {
  String _selectedPosition = 'Anchor';
  final List<String> _positions = ['Anchor', 'Pivot', 'Flank', 'Kiper'];
  String? selectedPemain;
  List<EmosionalModel> pemainList = [];
  List<EmosionalModel> filteredPemainList = [];
  List<EmosionalModel> selectedEmosionalPemainList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPemain();
  }

  Future<void> fetchPemain() async {
    try {
      List<EmosionalModel> pemain = await ApiService().fetchEmosiPemain();
      setState(() {
        pemainList = pemain;
        filteredPemainList = getPemainByPosisi(_selectedPosition);
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  List<EmosionalModel> getPemainByPosisi(String posisi) {
    return pemainList.where((pemain) => pemain.position == posisi).toList();
  }

  List<EmosionalModel> getPemainByName(String name) {
    return filteredPemainList.where((pemain) => pemain.name == name).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Penilaian Emosional Pemain',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () => _showAddEmosionalDialog(context),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Penilaian Pemain"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih Posisi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: size.width * 0.3,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey, width: 1.0),
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
                  selectedEmosionalPemainList = [];
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
            width: size.width * 0.3,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedPemain,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              items: filteredPemainList.map((EmosionalModel pemain) {
                return DropdownMenuItem<String>(
                  value: '${pemain.name}-${pemain.assessmentWeek}',
                  child: Text('${pemain.name} - ${pemain.assessmentWeek}'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPemain = newValue;
                  String selectedName = newValue!.split('-')[0];
                  selectedEmosionalPemainList = getPemainByName(selectedName);
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          if (selectedEmosionalPemainList.isNotEmpty) buildEmosionalData(size),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildEmosionalData(Size size) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: selectedEmosionalPemainList.map((pemain) {
              return Container(
                width: size.width * 0.3,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: cardBackgroundColor,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pemain.assessmentWeek,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aspek Emosional',
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
                    buildStatRow('Kedisiplinan', pemain.disciplineScore),
                    buildStatRow(
                        'Motivasi dan Semangat', pemain.motivationScore),
                    buildStatRow('Leadership', pemain.leadershipScore),
                    buildStatRow('Teamwork', pemain.teamworkScore),
                    buildStatRow('Kontrol Emosi', pemain.emotionalControlScore),
                    buildStatRow(
                        'Perkembangan Pemain', pemain.developmentScore),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
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
          Flexible(
            child: Text(
              statValue,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEmosionalDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Penilaian Emosional"),
          content: AddEmosionalDialog(
            onAdd: (EmosionalModel emosional) {
              setState(() {
                pemainList.add(emosional);
                filteredPemainList = getPemainByPosisi(_selectedPosition);
              });
            },
          ),
        );
      },
    );
  }
}
