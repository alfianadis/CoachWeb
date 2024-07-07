import 'package:coach_web/model/schedule_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:coach_web/config/responsive.dart';
import 'package:coach_web/utils/colors.dart';
import 'package:coach_web/utils/constant.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ScheduleModel> schedules = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    final fetchedSchedules = await apiService.fetchSchedules();
    setState(() {
      schedules = fetchedSchedules;
    });
  }

  Future<void> addSchedule(ScheduleModel schedule) async {
    await apiService.addSchedule(schedule);
    fetchSchedules();
  }

  void showAddScheduleDialog() {
    final _formKey = GlobalKey<FormState>();
    String activityName = '';
    DateTime activityTime = DateTime.now();
    String activityLocation = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Jadwal"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Nama Aktivitas"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama aktivitas tidak boleh kosong';
                    }
                    activityName = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Lokasi Aktivitas"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi aktivitas tidak boleh kosong';
                    }
                    activityLocation = value;
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScheduleModel newSchedule = ScheduleModel(
                        id: '',
                        activityName: activityName,
                        activityTime: activityTime,
                        activityLocation: activityLocation,
                      );
                      await addSchedule(newSchedule);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Tambah"),
                ),
              ],
            ),
          ),
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
                      onPressed: showAddScheduleDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Jadwal"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                schedules.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isMobile(context) ? 1 : 4,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          return ScheduleCard(schedule: schedule, size: size);
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

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.activityName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: size.width,
              child: const Divider(thickness: 1),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.greyColor,
                ),
                const SizedBox(width: 10),
                Text(
                  '${schedule.activityTime.toLocal()}'.split(' ')[0],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${schedule.activityTime.toLocal()}'.split(' ')[1],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.place,
                  color: AppColors.chart01,
                ),
                const SizedBox(width: 10),
                Text(
                  schedule.activityLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
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
