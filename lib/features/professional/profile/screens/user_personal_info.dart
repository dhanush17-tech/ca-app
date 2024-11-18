import 'package:ca_appoinment/app/const/shared_prefrence.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_divider.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/app/widgets/snack_bar.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:ca_appoinment/features/professional/profile/bloc/pro_user_bloc.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/app/common/providers/profile_provider.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProPersonalInfoScreen extends StatefulWidget {
  const ProPersonalInfoScreen({super.key});

  @override
  State<ProPersonalInfoScreen> createState() => _ProPersonalInfoScreenState();
}

class _ProPersonalInfoScreenState extends State<ProPersonalInfoScreen> {
// Personal Info Controllers
  var nameController = TextEditingController();
  var bithDateController = TextEditingController();
  var emailController = TextEditingController();
  var numberController = TextEditingController();
  var addressController = TextEditingController();
  String dGender = 'Male';
  DateTime? selectedDateTime;
  late String uId;
  ProfessionalAccountModel? arg;
  @override
  void initState() {
    super.initState();
    getUserModel();
  }

  getUserModel() async {
    var prefs = await SharedPreferences.getInstance();
    uId = prefs.getString(SharedPrefConst.uId)!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var argModel = ModalRoute.of(context)!.settings.arguments;
      if (argModel is ProfessionalAccountModel) {
        setState(() {
          arg = argModel;
          if (arg != null) {
            if (arg!.email != null) {
              emailController.text = arg!.email!;
            }
            if (arg!.userName != null) {
              nameController.text = arg!.userName!;
            }
            if (arg!.phoneNumber != null) {
              numberController.text = arg!.phoneNumber!;
            }
            if (arg!.address != null) {
              addressController.text = arg!.address!;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (arg != null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove default back button
          leading: const Padding(
            padding: EdgeInsets.all(3),
            child: MyIconPopButton(),
          ),
          title: const Text(
            'Update Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<UserProfileProvider>(
                builder: (context, provider, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            UserProfilePic(
                                url: arg!.profileUrl,
                                pickedImage: provider.pickedImage),
                            const SizedBox(height: 10),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: FittedBox(
                              child: CircleAvatar(
                            radius: 22,
                            backgroundColor: AppPalates.primary,
                            child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<UserProfileProvider>()
                                      .getImage();
                                },
                                child: const Icon(
                                  Icons.edit_note_outlined,
                                  color: AppPalates.white,
                                  size: 25,
                                )),
                          )),
                        )
                      ],
                    ),
                    Text(
                      nameController.text.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppPalates.black,
                          fontSize: 17),
                    ),
                    Text(
                      emailController.text.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppPalates.textGrey,
                          fontSize: 13),
                    ),
                    const MyDivider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppPalates.black),
                        ),
                        const MyDivider(),
                        MyTextFormField(
                            hintText: 'Full Name',
                            controller: nameController,
                            prefixIcon: Icons.person),
                        const SizedBox(height: 10),
                        MyTextFormField(
                            hintText: 'Email',
                            controller: emailController,
                            prefixIcon: Icons.email),
                        const SizedBox(height: 10),
                        MyTextFormField(
                            hintText: 'Address',
                            controller: addressController,
                            prefixIcon: Icons.location_on),
                        const SizedBox(height: 10),
                        MyTextFormField(
                            hintText: 'Phone Number',
                            controller: numberController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.numbers),
                        const SizedBox(height: 20),
                        BlocConsumer<ProUserBloc, ProUserState>(
                          listener: (context, state) {
                            if (state is ProUserSuccessState) {
                              provider.pickedImage = null;

                              Navigator.pop(context);

                              showSnackbar(
                                  context, 'Profile Update Successfully');
                            }
                            if (state is ProUserFailuerState) {
                              showSnackbar(context, state.errorMsg);
                            }
                          },
                          builder: (context, state) {
                            if (state is ProUserLoadingState) {
                              return SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: MyElevatedButton(
                                  btName: '',
                                  onTap: () {},
                                  widget: const CircularProgressIndicator(
                                    color: AppPalates.white,
                                  ),
                                ),
                              );
                            }
                            return SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: MyElevatedButton(
                                btName: 'Update',
                                onTap: () async {
                                  var email = emailController.text.trim();
                                  var name = nameController.text.trim();
                                  if (email.isNotEmpty && name.isNotEmpty) {
                                    context.read<ProUserBloc>().add(
                                        ProUserUpdateProfileEvent(
                                            newData: ProfessionalAccountModel(
                                                email: email,
                                                userName: name,
                                                phoneNumber: numberController
                                                    .text
                                                    .trim(),
                                                address: addressController.text
                                                    .trim()),
                                            profileImgFile:
                                                provider.pickedImage));
                                  }
                                },
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      );
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppPalates.primary,
        ),
      ),
    );
  }
}
