import 'package:flutter/material.dart';

class InviteGuest extends StatefulWidget {
  const InviteGuest({super.key});

  @override
  _InviteGuestState createState() => _InviteGuestState();
}

class _InviteGuestState extends State<InviteGuest> {
  final List<Map<String, String>> guests = [
    {"name": "", "phone": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Color(0xFF333333)),
        title: Text(
          'Invite Guest - Add',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Color(0xFFDDDDDD), height: 1),
        ),
      ),
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Past Visitors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Stack(
                                alignment: Alignment.center,
                                children: List.generate(5, (i) {
                                  return Positioned(
                                    left:
                                        (MediaQuery.of(context).size.width /
                                            2) -
                                        (5 * 20) +
                                        (i * 24),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xFFCCCCCC),
                                      backgroundImage: AssetImage(
                                        'assets/images/avatar3.png',
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Frequently added guest will be shown here',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),
                      Text(
                        'Invite Guest',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...guests.asMap().entries.map((entry) {
                              int idx = entry.key;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFEDEDED),
                                        hintText: 'Enter Guest Name',
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (v) => guests[idx]['name'] = v,
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFEDEDED),
                                        hintText: 'Enter Phone number',
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      onChanged:
                                          (v) => guests[idx]['phone'] = v,
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    guests.add({"name": "", "phone": ""});
                                  });
                                },
                                child: Text(
                                  '+ Add More',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF28A745),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Color(0xFFCCCCCC)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Or select from',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Color(0xFFCCCCCC)),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/images/icons/contact.png',
                                  width: 24,
                                  height: 24,
                                ),
                                label: Text(
                                  'Contacts',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF28A745),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF28A745),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Add Guest',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
