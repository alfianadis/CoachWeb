import 'package:coach_web/components/header.dart';
import 'package:coach_web/config/responsive.dart';
import 'package:coach_web/feature/add_schedule.dart';
import 'package:coach_web/model/schedule_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ScheduleModel> schedules = [];
  final ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    try {
      final fetchedSchedules = await apiService.fetchSchedules();
      setState(() {
        schedules = fetchedSchedules;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddScheduleDialog(
          onScheduleAdded: (newSchedule) {
            setState(() {
              schedules.add(newSchedule);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height * 0.3,
                  width: size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/schedule_banner.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    color: cardBackgroundColor,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jadwal Tim',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
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
                      onPressed: _showAddScheduleDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Jadwal"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : schedules.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: cardBackgroundColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Tidak ada jadwal",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
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
                                  childAspectRatio: 2 / 1, // Sesuaikan rasio
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: schedules.length,
                                itemBuilder: (context, index) {
                                  final schedule = schedules[index];
                                  return ScheduleCard(
                                      schedule: schedule, size: size);
                                },
                              );
                            },
                          ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final Size size;

  const ScheduleCard({required this.schedule, required this.size});

  String formatDateTime(DateTime dateTime) {
    final DateFormat dayFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final DateFormat timeFormat = DateFormat('HH:mm');
    return '${dayFormat.format(dateTime)}, ${timeFormat.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
            12.0), // Sesuaikan padding untuk menghemat ruang
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              schedule.activityName,
              style: const TextStyle(
                fontSize: 18, // Sesuaikan ukuran font
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.greyColor,
                  size: 14, // Sesuaikan ukuran ikon
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    formatDateTime(schedule.activityTime),
                    style: const TextStyle(
                      fontSize: 14, // Sesuaikan ukuran font
                      fontWeight: FontWeight.w200,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.place,
                  color: AppColors.chart01,
                  size: 14, // Sesuaikan ukuran ikon
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    schedule.activityLocation,
                    style: const TextStyle(
                      fontSize: 14, // Sesuaikan ukuran font
                      fontWeight: FontWeight.w200,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
