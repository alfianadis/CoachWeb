import 'package:flutter/material.dart';
import 'package:coach_web/model/schedule_model.dart';
import 'package:coach_web/service/api_service.dart';
import 'package:intl/intl.dart';

class AddScheduleDialog extends StatefulWidget {
  final Function(ScheduleModel) onScheduleAdded;

  const AddScheduleDialog({required this.onScheduleAdded});

  @override
  _AddScheduleDialogState createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _activityNameController = TextEditingController();
  final _activityTimeController = TextEditingController();
  final _activityLocationController = TextEditingController();
  final ApiService apiService = ApiService();
  DateTime? _selectedDateTime;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      final schedule = ScheduleModel(
        id: '', // ID akan di-generate oleh server
        activityName: _activityNameController.text,
        activityTime: _selectedDateTime!,
        activityLocation: _activityLocationController.text,
      );

      final response = await apiService.addSchedule(schedule);

      if (response != null) {
        widget.onScheduleAdded(response);
        Navigator.of(context).pop();
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Jadwal'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _activityNameController,
                decoration: InputDecoration(labelText: 'Nama Aktivitas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama aktivitas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activityTimeController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Waktu Aktivitas'),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _activityTimeController.text =
                            DateFormat('yyyy-MM-dd HH:mm')
                                .format(_selectedDateTime!);
                      });
                    }
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Waktu aktivitas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activityLocationController,
                decoration: InputDecoration(labelText: 'Lokasi Aktivitas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi aktivitas tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Tambah'),
        ),
      ],
    );
  }
}
