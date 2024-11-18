import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:ca_appoinment/app/const/shared_prefrence.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_divider.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/app/common/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/user_profile_pic.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  var nameController = TextEditingController();
  var bithDateController = TextEditingController();
  var emailController = TextEditingController();
  var numberController = TextEditingController();
  String dGender = 'Male';
  DateTime? selectedDateTime;
  late String uId;
  UserModel? arg;
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
      if (argModel is UserModel) {
        setState(() {
          arg = argModel;
          if (arg != null) {
            if (arg!.email != null) {
              emailController.text = arg!.email!;
            }
            if (arg!.name != null) {
              nameController.text = arg!.name!;
            }
            if (arg!.number != null) {
              numberController.text = arg!.number!;
            }
            if (arg!.gender != null) {
              dGender = arg!.gender!;
            }
            if (arg!.bithDate != null) {
              selectedDateTime = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(arg!.bithDate!));
            }
          }
        });
      }
    });
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
                        UserProfilePic(
                            url: arg!.profilePic,
                            pickedImage: provider.pickedImage),
                        const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
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
                    SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              value: dGender,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Male', child: Text('Male')),
                                DropdownMenuItem(
                                    value: 'Female', child: Text('Female')),
                                DropdownMenuItem(
                                    value: 'Other', child: Text('Other')),
                              ],
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppPalates.primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppPalates.primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppPalates.primary),
                                      borderRadius: BorderRadius.circular(10))),
                              onChanged: (value) {
                                dGender = value!;
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              child: MyElevatedButton(
                                btName: selectedDateTime != null
                                    ? DateFormat.yMMMEd()
                                        .format(selectedDateTime!)
                                    : 'Select BirthDate',
                                onTap: () async {
                                  var selectedDate = showDatePicker(
                                      context: context,
                                      firstDate:
                                          DateTime(DateTime.now().year - 25),
                                      lastDate: DateTime(
                                          DateTime.now().year - 5,
                                          DateTime.now().month,
                                          DateTime.now().day));
                                  selectedDateTime = await selectedDate;
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextFormField(
                        hintText: 'Phone Number',
                        controller: numberController,
                        prefixIcon: Icons.numbers),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 170,
                      height: 45,
                      child: BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is UserSuccessState) {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.home);
                            provider.pickedImage = null;
                          }
                        },
                        builder: (context, state) {
                          if (state is UserLoadingState) {
                            return MyElevatedButton(
                              btName: '',
                              onTap: () {},
                              widget: const CircularProgressIndicator(
                                color: AppPalates.white,
                              ),
                            );
                          }

                          return MyElevatedButton(
                            btName: 'Update',
                            textColor: emailController.text.isNotEmpty &&
                                    nameController.text.isNotEmpty
                                ? AppPalates.grey
                                : AppPalates.white,
                            onTap: () async {
                              var email = emailController.text.trim();
                              var name = nameController.text.trim();
                              var number = numberController.text.trim();
                              if (email.isNotEmpty && name.isNotEmpty) {
                                context.read<UserBloc>().add(UpdateProfileEvent(
                                    email: email,
                                    bithDate: selectedDateTime!
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    gender: dGender,
                                    name: name,
                                    number: number,
                                    profileImgFile: provider.pickedImage));
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      ),
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
