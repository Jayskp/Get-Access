import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/constants/colors.dart';
import '../../widgets/property_card.dart';

class SearchHomeScreen extends StatefulWidget {
  const SearchHomeScreen({Key? key}) : super(key: key);

  @override
  State<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends State<SearchHomeScreen> {
  // Toggle state for Rent vs Buy
  bool _isRentSelected = true;

  // Example lists for the dropdowns
  final List<String> _locations = [
    'Location 1',
    'Location 2',
    'Location 3',
  ];
  final List<String> _priceRanges = [
    '\$500 - \$1000',
    '\$1000 - \$1500',
    '\$1500 - \$2000',
  ];

  // Currently selected items
  String _selectedLocation = 'Location 1';
  String _selectedPriceRange = '\$500 - \$1000';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 26, right: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                children: [
                  Text(
                    "Homes",
                    style: _archivoTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Add your onPressed action here
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline_outlined,
                          color: Colors.white,
                          size: 17,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "Add Property",
                          style: _archivoTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(thickness: 1, color: AppColors.lightGrey),
              const SizedBox(height: 8),

              /// The updated container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.lightGrey,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// Rent/Buy toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            /// Rent
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isRentSelected = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _isRentSelected
                                        ? AppColors.primaryGreen
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      50
                                    ),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Rent",
                                    style: _archivoTextStyle(
                                      fontSize: 18,
                                      color: _isRentSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// Buy
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isRentSelected = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !_isRentSelected
                                        ? AppColors.primaryGreen
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                        50
                                    ),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Buy",
                                    style: _archivoTextStyle(
                                      fontSize: 18,
                                      color: !_isRentSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "What locations......",
                          hintStyle: _archivoTextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Location & Price Range Row
                    Row(
                      children: [
                        /// Location Dropdown
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedLocation,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                style: _archivoTextStyle(),
                                items: _locations.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: _archivoTextStyle(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedLocation = val!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// Price Range Dropdown
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedPriceRange,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                style: _archivoTextStyle(),
                                items: _priceRanges.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: _archivoTextStyle(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedPriceRange = val!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),

              Row(
                children: [
                  Expanded(child: Container(
                    decoration: BoxDecoration(
                      color:AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text("View Recent Properties",style: _archivoTextStyle(
                            color:Colors.grey
                          ),),
                          SizedBox(width: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                right: 4, // creates the "shadow" effect
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.home_outlined, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios,color:Colors.black,size:20,)

                        ],
                      ),),
                  ))
                ],
              ),
              SizedBox(height:20,),
              propertyCard(imageUrl: "assets/images/image.png", title:"Sahaj Flats", location:"Sola, Ahmedabad", price:"50,00,00", bhk:"3 BHK"),
              SizedBox(height:5,),
              propertyCard(imageUrl: "assets/images/image.png", title:"Sahaj Flats", location:"Sola, Ahmedabad", price:"50,00,00", bhk:"3 BHK"),
              SizedBox(height:16,),

              Text("Testimonials",style: _archivoTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),),
              SizedBox(height:16,),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("“There will be a scheduled power outage on Wednesday from 2 PM to 5 PM for maintenance. Sorry for the inconvenience”.",style:
                        _archivoTextStyle(fontSize: 16,color:Colors.black),),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Image(image: AssetImage("assets/images/icons/image.png")),
                          SizedBox(width:10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dhruv Patel",style: _archivoTextStyle(
                                
                              ),),
                              SizedBox(height:5,),
                              Text("Block A-102",style: _archivoTextStyle(
                                fontSize: 12,
                                color: Colors.grey
                              ),),
                              SizedBox(height:5,),
                              Text("Ahmedabad",style:_archivoTextStyle(
                                fontSize: 10,
                                color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Image(image: AssetImage("assets/images/icons/image.png")),
                          SizedBox(width:10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dhruv Patel",style: _archivoTextStyle(

                              ),),
                              SizedBox(height:5,),
                              Text("Block A-102",style: _archivoTextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                              ),),
                              SizedBox(height:5,),
                              Text("Ahmedabad",style:_archivoTextStyle(
                                  fontSize: 10,
                                  color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
