import 'package:flutter/material.dart';
import 'injection.dart';
import 'holiday_service.dart';
import 'holiday_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const HolidayApp());
}

class HolidayApp extends StatelessWidget {
  const HolidayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holiday Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HolidayScreen(),
    );
  }
}

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  final HolidayService _service = HolidayService();
  final TextEditingController _countryController = TextEditingController(text: 'RU');
  final TextEditingController _dateController = TextEditingController(text: '2026-01-01');

  List<Holiday> _holidays = [];
  bool _isLoading = false;
  String? _error;
  String? _infoMessage;

  Future<void> _loadHolidays() async {
    setState(() { _isLoading = true; _error = null; _infoMessage = null; });
    try {
      final list = await _service.fetchHolidays(_countryController.text.toUpperCase());
      setState(() { _holidays = list; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _checkDate() async {
    setState(() { _isLoading = true; _error = null; _infoMessage = null; });
    try {
      final result = await _service.checkDate(
        _countryController.text.toUpperCase(),
        _dateController.text,
      );
      setState(() {
        if (result.isHoliday) {
          _infoMessage = 'Да! Это праздник: ${result.holidayName}';
        } else {
          _infoMessage = 'Нет, это обычный рабочий день.';
        }
      });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _loadWorkingDays() async {
    setState(() { _isLoading = true; _error = null; _infoMessage = null; });
    try {
      final result = await _service.fetchWorkingDays(_countryController.text.toUpperCase());
      setState(() {
        _infoMessage = 'Рабочих дней: ${result.numWorkingDays}\nНерабочих дней: ${result.numNonWorkingDays}';
      });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь праздников'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Страна (ISO)',
                      border: OutlineInputBorder(),
                      hintText: 'RU, US, DE',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Дата (ГГГГ-ММ-ДД)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loadHolidays,
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text('Праздники'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _checkDate,
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('Проверить'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loadWorkingDays,
                    icon: const Icon(Icons.work, size: 18),
                    label: const Text('Дни'),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoading) const LinearProgressIndicator(),
          
          if (_infoMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_infoMessage!, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),

          Expanded(
            child: _holidays.isEmpty && !_isLoading
                ? const Center(child: Text('Нажмите "Праздники" для загрузки'))
                : ListView.builder(
                    itemCount: _holidays.length,
                    itemBuilder: (context, index) {
                      final h = _holidays[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.celebration, color: Colors.indigo),
                          title: Text(h.name),
                          subtitle: Text(h.date),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}