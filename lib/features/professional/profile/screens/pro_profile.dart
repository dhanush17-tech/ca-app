// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/professional/profile/bloc/pro_user_bloc.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/user/widgets/my_profile_tile.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/widgets/my_divider.dart';
import '../../../../app/widgets/my_loading_container.dart';

class ProProfileScreen extends StatefulWidget {
  const ProProfileScreen({super.key});

  @override
  State<ProProfileScreen> createState() => _ProProfileScreenState();
}

class _ProProfileScreenState extends State<ProProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProUserBloc>().add(ProUserFetchProfileEvent());
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
                    BlocBuilder<ProUserBloc, ProUserState>(
                      builder: (context, state) {
                        if (state is ProUserLoadingState) {
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
                        if (state is ProUserFailuerState) {
                          return Center(
                            child: Text(state.errorMsg),
                          );
                        }
                        if (state is ProUserSuccessState) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              UserProfilePic(
                                  url: state.proModel.profileUrl,
                                  pickedImage: null),
                              const SizedBox(height: 15),
                              Text(
                                state.proModel.userName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppPalates.black,
                                    fontSize: 17),
                              ),
                              Text(
                                state.proModel.email!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppPalates.textGrey,
                                    fontSize: 13),
                              ),
                              const SizedBox(height: 10),
                              if (!state.proModel.verified)
                                ActionRequiredWidget(model: state.proModel),
                              const SizedBox(height: 10),
                              const MyDivider(),
                              MyProfileTile(
                                icon: CupertinoIcons.profile_circled,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.proPersonalInfoScreen,
                                      arguments: state.proModel);
                                
                                },
                                title: 'Update Profile',
                              ),
                              MyProfileTile(
                                icon: CupertinoIcons.profile_circled,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.updateServiceInfo,
                                      arguments: state.proModel);
                                },
                                title: 'Update Service Details',
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

class ActionRequiredWidget extends StatelessWidget {
  ActionRequiredWidget({super.key, required this.model});
  ProfessionalAccountModel model;
  @override
  Widget build(BuildContext context) {
    return MyCardWidget(
      elevation: 0,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const Text(
              'Profile Action Required',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            MyElevatedButton(
                bgColor: AppPalates.red,
                btName: 'Update Infomation',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.updateServiceInfo,
                      arguments: model);
                })
          ]),
        ),
      ),
    );
  }
}
