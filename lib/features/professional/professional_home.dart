import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/professional/appoinments/screens/appoinment_screen.dart';
import 'package:ca_appoinment/features/professional/client/screen/client_screen.dart';
import 'package:ca_appoinment/features/professional/profile/screens/pro_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ProfesstionalHomeScreen extends StatefulWidget {
  const ProfesstionalHomeScreen({super.key});

  @override
  State<ProfesstionalHomeScreen> createState() =>
      _ProfesstionalHomeScreenState();
}

class _ProfesstionalHomeScreenState extends State<ProfesstionalHomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            ClientHome(),
            AppoinmentScreen(),
            ProProfileScreen(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: Column(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                height: 3,
              ),
              SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: SalomonBottomBar(
                    selectedItemColor: AppPalates.primary,
                    backgroundColor: Colors.white,
                    currentIndex: _currentIndex,
                    onTap: (p0) => setState(() {
                          _currentIndex = p0;
                        }),
                    items: [
                      SalomonBottomBarItem(
                        title: Text(
                          'Clients',
                        ),
                        icon: Icon(
                          Icons.view_list_outlined,
                          color: AppPalates.primary,
                        ),
                      ),
                      SalomonBottomBarItem(
                        title: Text(
                          'Appoitments',
                        ),
                        icon: Icon(
                          Icons.book_online_outlined,
                          color: AppPalates.primary,
                        ),
                      ),
                      SalomonBottomBarItem(
                        title: Text(
                          'Profile',
                        ),
                        icon: Icon(
                          Icons.person_outline_outlined,
                          color: AppPalates.primary,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: NavigationBar(
        //     indicatorShape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     elevation: 0,
        //     shadowColor: AppPalates.primary,
        //     surfaceTintColor: AppPalates.greyShade100,
        //     backgroundColor: AppPalates.white,
        //     onDestinationSelected: (value) {
        //       setState(() {
        //         _currentIndex = value;
        //       });
        //     },
        //     selectedIndex: _currentIndex,
        //     // : AppPalates.primary,
        //     indicatorColor: AppPalates.primary,
        //     destinations: const [
        //       NavigationDestination(
        //         label: 'Clients',
        //         selectedIcon: Icon(
        //           Icons.view_list_rounded,
        //           color: AppPalates.white,
        //         ),
        //         icon: Icon(
        //           Icons.list_rounded,
        //           color: AppPalates.primary,
        //         ),
        //       ),
        //       NavigationDestination(
        //         label: 'Appoinments',
        //         selectedIcon: Icon(
        //           Icons.book_online,
        //           color: AppPalates.white,
        //         ),
        //         icon: Icon(
        //           Icons.book_online_outlined,
        //           color: AppPalates.primary,
        //         ),
        //       ),
        //       NavigationDestination(
        //         label: 'Profile',
        //         selectedIcon: Icon(
        //           CupertinoIcons.profile_circled,
        //           color: AppPalates.white,
        //         ),
        //         icon: Icon(
        //           CupertinoIcons.profile_circled,
        //           color: AppPalates.primary,
        //         ),
        //       ),
        //     ]),
      ),
    );
  }
}
