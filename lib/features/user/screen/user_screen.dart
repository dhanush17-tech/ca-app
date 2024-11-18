// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/widgets/my_divider.dart';
import '../../../app/widgets/my_loading_container.dart';
import '../widgets/my_profile_tile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoadingState) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              CircleAvatar(
                                backgroundColor: AppPalates.greyShade100,
                                radius: 70,
                              ),
                              const SizedBox(height: 15),
                              MyLoadingContainer(),
                              const SizedBox(height: 5),
                              MyLoadingContainer(
                                width: 180,
                              ),
                              const SizedBox(height: 10),
                              MyLoadingContainer(
                                width: 160,
                                height: 55,
                              ),
                              const MyDivider(),
                              const SizedBox(height: 10),
                              Column(
                                children: List.generate(
                                    5,
                                    (index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          child: MyLoadingContainer(
                                            width: double.infinity,
                                            height: 55,
                                          ),
                                        )),
                              )
                            ],
                          );
                        }
                        if (state is UserFailuerState) {
                          return Center(
                            child: Text(state.errorMsg),
                          );
                        }
                        if (state is UserSuccessState) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              UserProfilePic(
                                  url: state.userModel.profilePic,
                                  pickedImage: null),
                              const SizedBox(height: 15),
                              Text(
                                state.userModel.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppPalates.black,
                                    fontSize: 17),
                              ),
                              Text(
                                state.userModel.email!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppPalates.textGrey,
                                    fontSize: 13),
                              ),
                              const SizedBox(height: 20),
                              const MyDivider(),
                              MyProfileTile(
                                icon: CupertinoIcons.profile_circled,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.personalInfoScreen,
                                      arguments: state.userModel);
                                },
                                title: 'Personal Information',
                              ),
                              MyProfileTile(
                                icon:
                                    CupertinoIcons.list_bullet_below_rectangle,
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      AppRoutes.bookedAppoinmnetScreen);
                                },
                                title: 'Appoinments',
                              ),
                              MyProfileTile(
                                icon: Icons.change_circle_outlined,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.changePasswordScreen);
                                },
                                title: 'Change Password',
                              ),
                              MyProfileTile(
                                icon: Icons.change_circle_outlined,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.forgetPasswordScreen);
                                },
                                title: 'Forget Password',
                              ),
                              MyProfileTile(
                                icon: Icons.battery_charging_full_rounded,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.creditScreen,
                                      arguments: state.userModel);
                                },
                                title: 'Buy Credits',
                              ),
                              const MyDivider(),
                              MyProfileTile(
                                icon: Icons.logout,
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthLogOutEvent());
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.logIn);
                                },
                                title: 'Log Out',
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
