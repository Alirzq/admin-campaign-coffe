import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../global-component/widget/custom_navbar.dart';
import '../../../../global-component/widget/tab_button.dart';
import '../earnings/earnings_page.dart';
import '../history/history_page.dart';

class HomepageView extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<HomepageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isStoreOpen = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/waving-hand.svg',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Hello",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                Text(
                  "Campaign Admin",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      TabButton(
                        title: "Earnings",
                        isSelected: _tabController.index == 0,
                        onTap: () => _tabController.animateTo(0),
                      ),
                      TabButton(
                        title: "History",
                        isSelected: _tabController.index == 1,
                        onTap: () => _tabController.animateTo(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                EarningsPage(),
                HistoryPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }

  void _toggleStore(bool value) {
    setState(() {
      isStoreOpen = value;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
}
