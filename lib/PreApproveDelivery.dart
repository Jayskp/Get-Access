import 'package:flutter/material.dart';

class PreApproveDelivery extends StatefulWidget {
  const PreApproveDelivery({Key? key}) : super(key: key);

  @override
  State<PreApproveDelivery> createState() => _PreApproveDeliveryState();
}

class _PreApproveDeliveryState extends State<PreApproveDelivery> {
  int selectedDay = 0;
  int selectedTime = 0;
  int selectedCompany = -1;
  bool anytime = false;
  bool collectAtGate = false;
  DateTime? selectedDate;

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
        if (date != null) {
          setState(() {
            selectedDate = date;
          });
        }
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
              ? 'Pick a date'
              : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String text, int value, {bool withIcon = false}) {
    final bool isSelected = selectedTime == value;

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
              color:
                  isSelected
                      ? Colors.green.withOpacity(0.2)
                      : Colors.grey.shade200,
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
          ),
        ],
      ),
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
          'Pre Approve Delivery',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Day of Visit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: anytime,
                      onChanged: (val) {
                        setState(() {
                          anytime = val ?? false;
                        });
                      },
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Text(
                      'Anytime in Day hours',
                      style: TextStyle(fontSize: 14, color: Colors.black),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDayToggle('Today', 0),
                      const SizedBox(width: 12),
                      _buildDayToggle('Tomorrow', 1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(child: _buildDatePickerButton()),
                  const SizedBox(height: 16),
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
                        '(The gate will expire after 2 hours)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: _buildTimeButton(
                            '10:30-11:00 AM',
                            0,
                            withIcon: true,
                          ),
                        ),
                      ),
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
              'Delivery Company',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompanyItem(
                  index: 0,
                  asset: 'assets/images/ola.png',
                  name: 'Ola',
                ),
                _buildCompanyItem(
                  index: 1,
                  asset: 'assets/images/uber.png',
                  name: 'Uber',
                ),
                _buildCompanyItem(
                  index: 2,
                  asset: 'assets/images/rapido.png',
                  name: 'Rapido',
                ),
                _buildCompanyItem(
                  index: 3,
                  asset: 'assets/images/icons/Circularplus2.png',
                  name: 'More',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: collectAtGate,
                  onChanged: (val) {
                    setState(() {
                      collectAtGate = val ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text(
                  'Collect My Parcels at the gate only',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
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
                onPressed: () {},
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
