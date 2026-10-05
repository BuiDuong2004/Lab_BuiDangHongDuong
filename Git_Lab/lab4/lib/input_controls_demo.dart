import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // Trạng thái các biến đầu vào
  double _ratingValue = 50.0;
  bool _isMovieActive = false;
  String _selectedGenre = 'None';
  DateTime? _selectedDate;

  // Hàm gọi DatePicker
  Future<void> _openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Contr...'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Slider Section
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _ratingValue,
              min: 0,
              max: 100,
              activeColor: const Color(0xFF5A628F),
              onChanged: (val) {
                setState(() {
                  _ratingValue = val;
                });
              },
            ),
            Text('Current value: ${_ratingValue.round()}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            // 2. Switch Section
            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Is movie active?', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _isMovieActive,
                  onChanged: (val) {
                    setState(() {
                      _isMovieActive = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. RadioListTile Section
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              onChanged: (val) {
                setState(() {
                  _selectedGenre = val!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              onChanged: (val) {
                setState(() {
                  _selectedGenre = val!;
                });
              },
            ),
            Text('Selected genre: $_selectedGenre',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            // 4. DatePicker Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFF2EFF7),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _openDatePicker(context),
                child: Text(
                  _selectedDate == null
                      ? 'Open Date Picker'
                      : 'Picked Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: const TextStyle(color: Color(0xFF5A628F), fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}