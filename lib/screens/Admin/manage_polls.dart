import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagePollsScreen extends StatefulWidget {
  final bool createNew;

  const ManagePollsScreen({Key? key, this.createNew = false}) : super(key: key);

  @override
  _ManagePollsScreenState createState() => _ManagePollsScreenState();
}

class _ManagePollsScreenState extends State<ManagePollsScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  List<Map<String, dynamic>> polls = [
    {
      'id': '1',
      'question':
          'What amenities would you like to see added to the community center?',
      'options': [
        'Swimming Pool',
        'Gym Equipment',
        'Children\'s Play Area',
        'Study Room',
      ],
      'startDate': '2024-07-01',
      'endDate': '2024-07-15',
      'isActive': true,
    },
    {
      'id': '2',
      'question':
          'Which day would you prefer for the monthly community meeting?',
      'options': [
        'Saturday Morning',
        'Sunday Evening',
        'Wednesday Evening',
        'Friday Evening',
      ],
      'startDate': '2024-07-05',
      'endDate': '2024-07-20',
      'isActive': true,
    },
    {
      'id': '3',
      'question': 'What color should we paint the community hall?',
      'options': ['Light Blue', 'Beige', 'Mint Green', 'Light Gray'],
      'startDate': '2024-06-15',
      'endDate': '2024-06-30',
      'isActive': false,
    },
  ];

  bool _isEditing = false;
  String? _editingId;
  bool _isActive = false;
  List<String> _options = ['', '', ''];
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    if (widget.createNew) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPollForm();
      });
    }
  }

  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.2,
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);

        // If end date is before start date, update end date
        if (_selectedEndDate != null && _selectedEndDate!.isBefore(picked)) {
          _selectedEndDate = picked.add(Duration(days: 14));
          _endDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(_selectedEndDate!);
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedEndDate ??
          (_selectedStartDate?.add(Duration(days: 14)) ??
              DateTime.now().add(Duration(days: 14))),
      firstDate: _selectedStartDate ?? DateTime.now(),
      lastDate: DateTime(2025, 12),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showPollForm({Map<String, dynamic>? poll}) {
    setState(() {
      _isEditing = poll != null;
      _editingId = poll?['id'];
      _questionController.text = poll?['question'] ?? '';
      _startDateController.text = poll?['startDate'] ?? '';
      _endDateController.text = poll?['endDate'] ?? '';
      _isActive = poll?['isActive'] ?? false;

      if (poll?['options'] != null) {
        _options = List<String>.from(poll!['options']);
      } else {
        _options = ['', '', ''];
      }

      if (poll?['startDate'] != null) {
        _selectedStartDate = DateTime.parse(poll!['startDate']);
      } else {
        _selectedStartDate = null;
      }

      if (poll?['endDate'] != null) {
        _selectedEndDate = DateTime.parse(poll!['endDate']);
      } else {
        _selectedEndDate = null;
      }
    });

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text(
                    _isEditing ? 'Edit Poll' : 'Create Poll',
                    style: _archivoTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _questionController,
                          decoration: InputDecoration(
                            labelText: 'Question',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Options:',
                          style: _archivoTextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ..._buildOptionFields(setDialogState),
                        TextButton.icon(
                          onPressed: () {
                            setDialogState(() {
                              _options.add('');
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.red),
                          label: Text(
                            'Add Option',
                            style: _archivoTextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _startDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectStartDate(context),
                            ),
                          ),
                          onTap: () => _selectStartDate(context),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _endDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectEndDate(context),
                            ),
                          ),
                          onTap: () => _selectEndDate(context),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _isActive,
                              onChanged: (value) {
                                setDialogState(() {
                                  _isActive = value ?? false;
                                });
                              },
                              activeColor: Colors.red,
                            ),
                            Text(
                              'Active poll',
                              style: _archivoTextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearForm();
                      },
                      child: Text(
                        'Cancel',
                        style: _archivoTextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate form
                        if (_questionController.text.isEmpty ||
                            _startDateController.text.isEmpty ||
                            _endDateController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                          return;
                        }

                        // Filter out empty options
                        final validOptions =
                            _options
                                .where((option) => option.trim().isNotEmpty)
                                .toList();
                        if (validOptions.length < 2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please add at least 2 options'),
                            ),
                          );
                          return;
                        }

                        // Save options back to state for form rebuilding
                        _options = validOptions;

                        if (_isEditing) {
                          _updatePoll(validOptions);
                        } else {
                          _createPoll(validOptions);
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        _isEditing ? 'Update' : 'Create',
                        style: _archivoTextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  List<Widget> _buildOptionFields(StateSetter setDialogState) {
    return List.generate(_options.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Option ${index + 1}',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                initialValue: _options[index],
                onChanged: (value) {
                  _options[index] = value;
                },
              ),
            ),
            if (_options.length > 2)
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red.shade300),
                onPressed: () {
                  setDialogState(() {
                    _options.removeAt(index);
                  });
                },
              ),
          ],
        ),
      );
    });
  }

  void _clearForm() {
    setState(() {
      _questionController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _options = ['', '', ''];
      _isActive = false;
      _selectedStartDate = null;
      _selectedEndDate = null;
    });
  }

  void _createPoll(List<String> validOptions) {
    final newPoll = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'question': _questionController.text,
      'options': validOptions,
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
      'isActive': _isActive,
    };

    setState(() {
      polls.add(newPoll);
      _clearForm();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Poll created successfully')));
  }

  void _updatePoll(List<String> validOptions) {
    final index = polls.indexWhere((poll) => poll['id'] == _editingId);
    if (index != -1) {
      setState(() {
        polls[index] = {
          'id': _editingId,
          'question': _questionController.text,
          'options': validOptions,
          'startDate': _startDateController.text,
          'endDate': _endDateController.text,
          'isActive': _isActive,
        };
        _clearForm();
        _editingId = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Poll updated successfully')));
    }
  }

  void _deletePoll(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Poll'),
            content: Text('Are you sure you want to delete this poll?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    polls.removeWhere((poll) => poll['id'] == id);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Poll deleted successfully')),
                  );
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _togglePollStatus(String id, bool newStatus) {
    final index = polls.indexWhere((poll) => poll['id'] == id);
    if (index != -1) {
      setState(() {
        polls[index]['isActive'] = newStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus
                ? 'Poll activated successfully'
                : 'Poll deactivated successfully',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort polls: active first, then by end date (newest end date first)
    final sortedPolls = [...polls];
    sortedPolls.sort((a, b) {
      if (a['isActive'] && !b['isActive']) return -1;
      if (!a['isActive'] && b['isActive']) return 1;
      return b['endDate'].compareTo(a['endDate']);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Polls',
          style: _archivoTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'ADMIN',
                  style: _archivoTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            sortedPolls.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.poll, size: 80, color: Colors.grey.shade400),
                      SizedBox(height: 16),
                      Text(
                        'No polls yet',
                        style: _archivoTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your first poll by tapping the + button below',
                        textAlign: TextAlign.center,
                        style: _archivoTextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedPolls.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final poll = sortedPolls[index];
                    return _buildPollCard(poll);
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPollForm(),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Poll',
      ),
    );
  }

  Widget _buildPollCard(Map<String, dynamic> poll) {
    // Parse dates and format them for display
    final DateTime startDate = DateTime.parse(poll['startDate']);
    final DateTime endDate = DateTime.parse(poll['endDate']);
    final String formattedStartDate = DateFormat(
      'MMM d, yyyy',
    ).format(startDate);
    final String formattedEndDate = DateFormat('MMM d, yyyy').format(endDate);

    final bool isExpired = endDate.isBefore(DateTime.now());
    final bool hasStarted = startDate.isBefore(DateTime.now());

    // Status text and color
    String statusText;
    Color statusColor;

    if (poll['isActive']) {
      if (isExpired) {
        statusText = 'Completed';
        statusColor = Colors.grey;
      } else if (hasStarted) {
        statusText = 'Active';
        statusColor = Colors.green;
      } else {
        statusText = 'Upcoming';
        statusColor = Colors.blue;
      }
    } else {
      statusText = 'Inactive';
      statusColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              poll['isActive']
                  ? (isExpired ? Colors.grey.shade300 : Colors.blue.shade300)
                  : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  poll['isActive']
                      ? (isExpired ? Colors.grey.shade200 : Colors.blue.shade50)
                      : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    poll['question'],
                    style: _archivoTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          poll['isActive']
                              ? (isExpired
                                  ? Colors.grey.shade700
                                  : Colors.blue.shade900)
                              : Colors.grey.shade700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: _archivoTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateRange(formattedStartDate, formattedEndDate),
                SizedBox(height: 16),
                Text(
                  'Options:',
                  style: _archivoTextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8),
                ...poll['options']
                    .map<Widget>(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 8),
                            Text(
                              option,
                              style: _archivoTextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Toggle active status
                TextButton.icon(
                  onPressed:
                      () => _togglePollStatus(poll['id'], !poll['isActive']),
                  icon: Icon(
                    poll['isActive'] ? Icons.toggle_on : Icons.toggle_off,
                    color: poll['isActive'] ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                  label: Text(
                    poll['isActive'] ? 'Active' : 'Inactive',
                    style: _archivoTextStyle(
                      color: poll['isActive'] ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showPollForm(poll: poll),
                      icon: Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: () => _deletePoll(poll['id']),
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRange(String startDate, String endDate) {
    return Row(
      children: [
        Icon(Icons.date_range, size: 16, color: Colors.grey.shade600),
        SizedBox(width: 8),
        Text(
          '$startDate - $endDate',
          style: _archivoTextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
