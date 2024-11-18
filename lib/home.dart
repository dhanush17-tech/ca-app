import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_divider.dart';
import 'package:ca_appoinment/features/expense_manager/screen/expense.dart';
import 'package:ca_appoinment/features/fa/screens/fa_screen.dart';
import 'package:ca_appoinment/features/tax/screens/select_ca_screen.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/features/user/screen/user_screen.dart';
import 'package:ca_appoinment/features/user/widgets/my_profile_tile.dart';
import 'package:ca_appoinment/features/user/widgets/user_over_view_widgets.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    context.read<UserBloc>().add(FetchProfileEvent());
  }

  final screens = const [
    ExpenseScreen(),
    TaxFillingScreen(),
    FaScreen(),
    UserProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 70,
          child: Column(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                height: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: SalomonBottomBar(
                    selectedItemColor: AppPalates.primary,
                    backgroundColor: Colors.white,
                    currentIndex: _currentIndex,
                    onTap: (p0) => setState(() {
                          _currentIndex = p0;
                        }),
                    // height: 60,
                    // indicatorShape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    // elevation: 0,
                    // shadowColor: AppPalates.primary,
                    // surfaceTintColor: AppPalates.greyShade100,
                    // backgroundColor: AppPalates.white,
                    // onDestinationSelected: (value) {
                    //   setState(() {
                    //     _currentIndex = value;
                    //   });
                    // },
                    // selectedIndex: _currentIndex,
                    // // : AppPalates.primary,
                    // indicatorColor: AppPalates.primary,

                    items: [
                      SalomonBottomBarItem(
                        title: const Text(
                          'Expense',
                        ),
                        icon: const Icon(
                          Icons.pie_chart_outline,
                          color: AppPalates.primary,
                        ),
                      ),
                      SalomonBottomBarItem(
                        title: const Text(
                          'Tax',
                        ),
                        icon: const Icon(
                          Icons.library_books,
                          color: AppPalates.primary,
                        ),
                      ),
                      SalomonBottomBarItem(
                        title: const Text(
                          'Advisor',
                        ),
                        icon: const Icon(
                          Icons.build_outlined,
                          color: AppPalates.primary,
                        ),
                      ),
                      SalomonBottomBarItem(
                        title: const Text(
                          'Settings',
                        ),
                        icon: const Icon(
                          CupertinoIcons.settings_solid,
                          weight: 10,
                          color: AppPalates.primary,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: AppPalates.white,
          surfaceTintColor: AppPalates.white,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                    },
                    child: const UserOverView()),
                const MyDivider(),
                MyProfileTile(
                    icon: null,
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRoutes.bookedAppoinmnetScreen);
                    },
                    title: 'My Appoinments'),
                MyProfileTile(icon: null, onTap: () {}, title: 'Ai Chat Help'),
                MyProfileTile(icon: null, onTap: () {}, title: 'Feedback'),
              ],
            ),
          )),
        ),
        appBar: _currentIndex == 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserSuccessState) {
                      return AppBar(
                        leadingWidth: 70,
                        automaticallyImplyLeading: false,
                        leading: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: UserProfilePic(
                              url: state.userModel.profilePic,
                              picRadius: 20,
                            ),
                          ),
                        ),
                        titleSpacing: 0,
                        elevation: 0,
                        title: Text(
                          'Welcome, ${state.userModel.name}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15,
                              color: AppPalates.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w900),
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(

                                   AppRoutes.creditScreen,
                                  arguments: state.userModel,
                                  );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 1, color: AppPalates.black),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    color: AppPalates.metalicGold,
                                  ),
                                  Text(state.userModel.credit!.toString()),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10)
                        ],
                      );
                    }
                    if (state is UserLoadingState) {
                      return AppBar(
                          leading: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppPalates.greyShade100,
                            ),
                          ),
                          leadingWidth: 70,
                          automaticallyImplyLeading: false,
                          title: Container(
                            width: 150,
                            height: 30,
                            decoration: BoxDecoration(
                                color: AppPalates.greyShade100,
                                borderRadius: BorderRadius.circular(10)),
                          ));
                    }
                    return AppBar();
                  },
                ),
              )
            : null,
        body: screens[_currentIndex],
      ),

      // bottomNavigationBar: SalomonBottomBar(
      //     currentIndex: _currentIndex,
      //     onTap: (p0) => setState(() {
      //           _currentIndex = p0;
      //         }),
      //     // height: 60,
      //     // indicatorShape: RoundedRectangleBorder(
      //     //   borderRadius: BorderRadius.circular(12),
      //     // ),
      //     // elevation: 0,
      //     // shadowColor: AppPalates.primary,
      //     // surfaceTintColor: AppPalates.greyShade100,
      //     // backgroundColor: AppPalates.white,
      //     // onDestinationSelected: (value) {
      //     //   setState(() {
      //     //     _currentIndex = value;
      //     //   });
      //     // },
      //     // selectedIndex: _currentIndex,
      //     // // : AppPalates.primary,
      //     // indicatorColor: AppPalates.primary,

      //     items: [
      //       SalomonBottomBarItem(
      //         title: Text(
      //           'Expense',
      //         ),
      //         icon: Icon(
      //           Icons.pie_chart_outline,
      //           color: AppPalates.primary,
      //         ),
      //       ),
      //       SalomonBottomBarItem(
      //         title: Text(
      //           'Tax',
      //         ),
      //         icon: Icon(
      //           Icons.library_books,
      //           color: AppPalates.primary,
      //         ),
      //       ),
      //       SalomonBottomBarItem(
      //         title: Text(
      //           'Advisor',
      //         ),
      //         icon: Icon(
      //           Icons.build_outlined,
      //           color: AppPalates.primary,
      //         ),
      //       ),
      //       SalomonBottomBarItem(
      //         title: Text(
      //           'Settings',
      //         ),
      //         icon: Icon(
      //           CupertinoIcons.settings_solid,
      //           weight: 10,
      //           color: AppPalates.primary,
      //         ),
      //       ),
      //     ]),
    );
  }
}
