import 'package:coach_web/model/statik_player_model.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

class PlayerSubTable extends StatelessWidget {
  const PlayerSubTable({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.75,
      width: size.width * 0.38,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pemain Cadangan",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Nama Pemain"),
                ),
                DataColumn(
                  label: Text("Posisi"),
                ),
                DataColumn(
                  label: Text("No Punggung"),
                ),
              ],
              rows: List.generate(
                demoRecentFiless.length,
                (index) => recentFileDataRow(demoRecentFiless[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow recentFileDataRow(RecentFile fileInfo) {
    return DataRow(
      cells: [
        DataCell(Text(fileInfo.name!)),
        DataCell(Text(fileInfo.posisi!)),
        DataCell(Text(fileInfo.no!)),
      ],
    );
  }
}
