import 'package:flutter/material.dart';

class PreApproveMaid extends StatefulWidget {
  const PreApproveMaid({Key? key}) : super(key: key);

  @override
  State<PreApproveMaid> createState() => _PreApproveMaidState();
}

class _PreApproveMaidState extends State<PreApproveMaid> {
  int selectedDay = 0;
  int selectedTime = 0;
  bool anytime = false;
  DateTime? selectedDate;
  String maidName = '';
  String maidNumber = '';
  String maidCompany = '';

  Widget _buildDayToggle(String text, int value) {
    bool isSelected = selectedDay == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedDay = value),
        child: Container(
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton() {
    return GestureDetector(
      onTap: () async {
        DateTime initDate = selectedDate ?? DateTime.now();
        DateTime firstDate =
            selectedDay == 0
                ? DateTime.now()
                : DateTime.now().add(const Duration(days: 1));
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: initDate,
          firstDate: firstDate,
          lastDate: DateTime(2100),
        );
        if (date != null) setState(() => selectedDate = date);
      },
      child: Container(
        width: double.infinity,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          selectedDate == null
              ? 'Pick a Date'
              : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String text, int value, {bool withIcon = false}) {
    bool isSelected = selectedTime == value;
    return GestureDetector(
      onTap: () => setState(() => selectedTime = value),
      child: Container(
        width: double.infinity,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(isSelected ? 22 : 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (withIcon)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.asset(
                  'assets/images/icons/clock.png',
                  width: 16,
                  height: 16,
                ),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, ValueChanged<String> onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Pre Approve Maid', style: TextStyle(fontSize: 18)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Day of Visit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: anytime,
                      onChanged:
                          (val) => setState(() => anytime = val ?? false),
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Text(
                      'Anytime in Day hours',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildDayToggle('Today', 0),
                      const SizedBox(width: 12),
                      _buildDayToggle('Tomorrow', 1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDatePickerButton(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '(The gate pass will expire after 2 hours)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      _buildTimeButton('10:30 - 11:00 AM', 0, withIcon: true),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeButton('In next 30 mins', 1),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTimeButton('In next 1 hour', 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Maid Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField('Name', (val) => setState(() => maidName = val)),
            const SizedBox(height: 12),
            _buildTextField(
              'Number',
              (val) => setState(() => maidNumber = val),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Company',
              (val) => setState(() => maidCompany = val),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  debugPrint('Maid Name: $maidName');
                  debugPrint('Maid Number: $maidNumber');
                  debugPrint('Maid Company: $maidCompany');
                },
                child: const Text(
                  'Notify Guard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
