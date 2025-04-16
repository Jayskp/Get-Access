import 'package:flutter/material.dart';

class ServiceDirectory extends StatefulWidget {
  @override
  _ServiceDirectoryState createState() => _ServiceDirectoryState();
}

class _ServiceDirectoryState extends State<ServiceDirectory> {
  final List<Map<String, String>> services = List.generate(8, (i) {
    final positions = ['Milkman', 'Security', 'Plumber', 'Electrician'];
    final colors = [0xFFFFE5E5, 0xFFFFF4E5, 0xFFFFF0E5, 0xFFE5FFF0];
    final textColors = [0xFFD32F2F, 0xFFF57C00, 0xFFE65100, 0xFF388E3C];
    final pos = positions[i % positions.length];
    return {
      "name": "Brijesh",
      "position": pos,
      "bgColor": colors[i % colors.length].toString(),
      "textColor": textColors[i % textColors.length].toString(),
      "phone": "Ph no: 0123456789",
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Color(0xFF333333)),
        title: Text(
          'Service Directory',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/icons/search.png',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Directory',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/icons/filter.png',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (ctx, i) {
                  final s = services[i];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(
                              'assets/images/profile.png',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s['name']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(s['bgColor']!)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    s['position']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(int.parse(s['textColor']!)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  s['phone']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/icons/call.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Call',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF28A745),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
