import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/constants/colors.dart';
import '../../widgets/categories_card.dart';
import '../../widgets/social_services_card.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
  final List<Map<String, String>> categoryItems = [

    {
      "iconPath": "assets/images/icons/Services.png",
      "title": "Services by Urab",
    },
    {
      "iconPath": "assets/images/icons/car.side.arrowtriangle.down.png",
      "title": "Airport Cabs",
    },
    {
      "iconPath": "assets/images/icons/tabler_truck-delivery.png",
      "title": "Movers & Packers",

    },
    {
      "iconPath": "assets/images/icons/bucket.png",
      "title": "Cleaning",

    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 26, right: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Services",
                      style: _archivoTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search_rounded, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(color: Colors.grey),
                const SizedBox(height: 8),
                Text("Categories",style: _archivoTextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black
                ),),
                SizedBox(height: 16,),
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: categoryItems.length,
                  itemBuilder: (context, index) {
                    return CategoriesCard(
                      iconPath: categoryItems[index]["iconPath"] ?? "",
                      title: categoryItems[index]["title"] ?? "",
                    );
                  },
                ),
                SizedBox(height:16,),
                Text("Trending Services",style: _archivoTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black
                ),),
                SizedBox(height:16,),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    ServiceCard(
                      image: 'assets/images/truck.png',
                      title: 'Porter Packers & Movers',
                      onTap: () {},
                    ),
                    ServiceCard(
                      image: 'assets/images/locks.png',
                      title: 'Okinava Smart Locks',
                      onTap: () {},
                    ),
                    ServiceCard(
                      image: 'assets/images/cabs.png',
                      title: 'Airport Cabs',
                      onTap: () {},
                    ),
                    ServiceCard(
                      image: 'assets/images/medical.png',
                      title: 'Instant Medical Help',
                      onTap: () {},
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
