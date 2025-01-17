import 'package:coach_web/components/header.dart';
import 'package:coach_web/config/responsive.dart';
import 'package:coach_web/feature/add_player.dart';
import 'package:flutter/material.dart';
import 'package:coach_web/model/player_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/constant.dart';

class PemainScreen extends StatefulWidget {
  @override
  _PemainScreenState createState() => _PemainScreenState();
}

class _PemainScreenState extends State<PemainScreen> {
  late Future<List<PlayerModel>> futurePlayers;

  @override
  void initState() {
    super.initState();
    futurePlayers = ApiService().getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 55, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Header(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'List Pemain',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AddPlayerDialog(),
                      ).then((value) {
                        if (value != null && value) {
                          setState(() {
                            futurePlayers = ApiService().getPlayers();
                          });
                        }
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Pemain"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<PlayerModel>>(
                future: futurePlayers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No players found'));
                  } else {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: buildPositionSection(context, size,
                                  'Posisi Anchor', snapshot.data!, 'Anchor'),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: buildPositionSection(context, size,
                                  'Posisi Pivot', snapshot.data!, 'Pivot'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: buildPositionSection(context, size,
                                  'Posisi Flank', snapshot.data!, 'Flank'),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: buildPositionSection(context, size,
                                  'Posisi Kiper', snapshot.data!, 'Kiper'),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPositionSection(BuildContext context, Size size, String title,
      List<PlayerModel> players, String position) {
    List<PlayerModel> filteredPlayers =
        players.where((player) => player.position == position).toList();

    double containerHeight = 60.0 + (filteredPlayers.length * 80.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: containerHeight,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: cardBackgroundColor,
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  color: cardForegroundColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nama Pemain',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'No Punggung',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPlayers.length,
                  itemBuilder: (context, index) {
                    PlayerModel player = filteredPlayers[index];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: ListTile(
                            title: Text(
                              player.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Text(
                              player.jerseyNumber.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 1,
                          color: backgroundColor,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
