// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_loading_container.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserOverView extends StatefulWidget {
  const UserOverView({
    super.key,
  });

  @override
  State<UserOverView> createState() => _UserOverViewState();
}

class _UserOverViewState extends State<UserOverView> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  backgroundColor: AppPalates.greyShade100,
                  radius: 70,
                ),
                const SizedBox(height: 15),
                MyLoadingContainer(),
                const SizedBox(height: 10),
                MyLoadingContainer(
                  width: 180,
                ),
                const SizedBox(height: 20),
                MyLoadingContainer(
                  width: 160,
                  height: 55,
                ),
              ],
            ),
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
              const SizedBox(height: 10),
              UserProfilePic(url: state.userModel.profilePic, pickedImage: null),
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
                    fontWeight: FontWeight.w900,
                    color: AppPalates.textGrey,
                    fontSize: 13),
              ),
              const SizedBox(height: 20),
              MyElevatedButton(
                  btName: 'Edit Profile',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.personalInfoScreen,
                        arguments: state.userModel);
                  })
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
