import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PreApproveCab extends StatefulWidget {
  const PreApproveCab({Key? key}) : super(key: key);

  @override
  State<PreApproveCab> createState() => _PreApproveCabState();
}

class _PreApproveCabState extends State<PreApproveCab> {
  int selectedDay = 0;
  int selectedTime = 0;
  int selectedCompany = -1;
  bool longHourVisit = false;
  DateTime? selectedDate;

  // This will hold the value of the car number (OTP-like)
  String carNumber = '';

  // Helper method to build a toggle button for "Today" or "Tomorrow."
  Widget _buildDayToggle(String text, int value) {
    bool isSelected = selectedDay == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = value;
        });
      },
      child: Container(
        width: 120,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
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
    );
  }

  // Builds a button to open a date picker widget
  Widget _buildDatePickerButton() {
    return GestureDetector(
      onTap: () async {
        DateTime initDate = selectedDate ?? DateTime.now();
        // If 'Today' is selected, firstDate is 'now', else it’s tomorrow.
        DateTime firstDate =
        selectedDay == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: initDate,
          firstDate: firstDate,
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            selectedDate = date;
          });
        }
      },
      child: Container(
        width: 140,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          selectedDate == null
              ? 'Pick a date'
              : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  // Helper to build time selection buttons
  Widget _buildTimeButton(String text, int value, {bool withIcon = false}) {
    bool isSelected = selectedTime == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = value;
        });
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.2) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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

  // Helper to build a company/logo item
  Widget _buildCompanyItem({
    required int index,
    required String asset,
    required String name,
  }) {
    bool isSelected = selectedCompany == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCompany = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.2) : Colors.grey.shade200,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Image.asset(asset, width: 32, height: 32),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  // Helper to build the car number field in an OTP style
  Widget _buildCarNumberField() {
    return PinCodeTextField(
      appContext: context,
      length: 6, // Adjust length as needed for your car number format
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.text,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 50,
        fieldWidth: 40,
        activeColor: Colors.green,
        inactiveColor: Colors.grey.shade300,
        selectedColor: Colors.blue,
      ),
      animationDuration: const Duration(milliseconds: 300),
      onChanged: (value) {
        setState(() {
          carNumber = value;
        });
      },
      onCompleted: (value) {
        // Optionally handle the completed event
        debugPrint('Car Number Completed: $value');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Pre Approve Cab',
          style: TextStyle(fontSize: 18),
        ),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Day of Visit and Long Hour Visit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Day of Visit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              Row(
                children: [
                  Checkbox(
                    value: longHourVisit,
                    onChanged: (val) {
                      setState(() {
                        longHourVisit = val ?? false;
                      });
                    },
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  const Text(
                    'Long hour visit',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date Selection + Time Selections
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Toggle for Today / Tomorrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDayToggle('Today', 0),
                    _buildDayToggle('Tomorrow', 1),
                  ],
                ),
                const SizedBox(height: 16),
                Center(child: _buildDatePickerButton()),
                const SizedBox(height: 16),

                // Time Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      '(The gate pass will expire after 2 hours)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Center(
                      child: _buildTimeButton('10:30 - 11:00 AM', 0, withIcon: true),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTimeButton('In next 30 mins', 1),
                        _buildTimeButton('In next 1 hour', 2),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Car Company
          const Text(
            'Car Company',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCompanyItem(index: 0, asset: 'assets/images/ola.png', name: 'Ola'),
              _buildCompanyItem(index: 1, asset: 'assets/images/uber.png', name: 'Uber'),
              _buildCompanyItem(index: 2, asset: 'assets/images/rapido.png', name: 'Rapido'),
              _buildCompanyItem(index: 3, asset: 'assets/images/circular-plus.png', name: 'More'),
            ],
          ),
          const SizedBox(height: 16),

          // Car Number (OTP-like) Field
          const Text(
            'Car Number',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 8),
          _buildCarNumberField(),
          const SizedBox(height: 24),

          // Notify Guard Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Example usage of carNumber
                debugPrint('Car Number: $carNumber');
                // Add your submission logic here
              },
              child: const Text(
                'Notify Guard',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
