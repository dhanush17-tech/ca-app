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
import 'package:ca_appoinment/features/tax/widgets/professional_account_succes_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateServiceInfo extends StatefulWidget {
  const UpdateServiceInfo({super.key});

  @override
  State<UpdateServiceInfo> createState() => _UpdateServiceInfoState();
}

class _UpdateServiceInfoState extends State<UpdateServiceInfo> {
// Service Info Controller
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
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
      var argModel = ModalRoute.of(context)!.settings.arguments
          as ProfessionalAccountModel;
      setState(() {
        arg = argModel;
        if (arg!.title != null) {
          titleController.text = arg!.title!;
        }
        if (arg!.description != null) {
          descriptionController.text = arg!.description!;
        }
      });
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
                  child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfessionalProfileContainer(
                        ca: arg!, isDummy: true, title: titleController.text),
                    Row(
                      children: [
                        const Text(
                          'Service Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppPalates.black),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(CupertinoIcons.refresh_thin))
                      ],
                    ),
                    const MyDivider(),
                    MyTextFormField(
                        hintText: 'Title',
                        validator: (value) {
                          if (value!.length <= 8) {
                            return 'title have minimum length of 8 characters';
                          }
                          return null;
                        },
                        controller: titleController,
                        prefixIcon: Icons.title,
                        keyboardType: TextInputType.text),
                    const SizedBox(height: 10),
                    MyTextFormField(
                        hintText: 'Description',
                        validator: (value) {
                          if (value!.length <= 50) {
                            return 'description have minimum length of 50 characters';
                          }
                          return null;
                        },
                        controller: descriptionController,
                        prefixIcon: Icons.description_rounded,
                        keyboardType: TextInputType.text),
                    const SizedBox(height: 20),
                    BlocConsumer<ProUserBloc, ProUserState>(
                      listener: (context, state) {
                        if (state is ProUserSuccessState) {
                          provider.pickedImage = null;

                          Navigator.pop(context);

                          showSnackbar(context, 'Profile Update Successfully');
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
                              if (_formKey.currentState!.validate()) {
                                var title = titleController.text.trim();
                                var description =
                                    descriptionController.text.trim();
                                if (title.isNotEmpty &&
                                    description.isNotEmpty) {
                                  context.read<ProUserBloc>().add(
                                      ProUserCheckVerifyEvent(
                                          newData: ProfessionalAccountModel(
                                            title: title,
                                            description: description,
                                          )));
                                }
                              }
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ));
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
