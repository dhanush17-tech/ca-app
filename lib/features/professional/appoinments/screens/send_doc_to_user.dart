import 'dart:io';

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/core/push_notification_service.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/file_pick_container.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/app/widgets/snack_bar.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:ca_appoinment/features/user/blocs/booked_appointment_bloc/booked_appoinments_bloc.dart';
import 'package:ca_appoinment/features/bookings/blocs/doc_upload_bloc/doc_upload_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SendDocsToUser extends StatefulWidget {
  const SendDocsToUser({super.key});

  @override
  State<SendDocsToUser> createState() => _SendDocsToUserState();
}

class _SendDocsToUserState extends State<SendDocsToUser> {
  File? file;
  var fileNameController = TextEditingController();
  BookingTimeModel? bookingTimeModel;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var arg = ModalRoute.of(context)!.settings.arguments;
      if (arg is BookingTimeModel) {
        setState(() {
          bookingTimeModel = arg;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bookingTimeModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(3),
          child: MyIconPopButton(),
        ),
        title: const Text(
          'Submit Document',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppPalates.black),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              MyTextFormField(
                  validator: (value) {
                    if (value!.trim().length <= 5) {
                      return 'File Name Must Be at least 5 characters';
                    }
                    return null;
                  },
                  hintText: "file Name",
                  controller: fileNameController,
                  prefixIcon: Icons.file_copy),
              const SizedBox(height: 10),
              FilePickContainer(
                aadhaarFile: file,
                ontap: () async {
                  var selectImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (selectImage != null) {
                    setState(() {
                      file = File(selectImage.path);
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: BlocConsumer<DocUploadBloc, DocUploadState>(
                  listener: (context, state) {
                    if (state is DocUploadFailuerState) {
                      showSnackbar(context, state.errorMsg);
                    } else if (state is DocUploadSuccesState) {
                      showSnackbar(context, 'Document Upload Successfully');
                      var model = state.docs;
                      PushNotificationService.sendNotificationToSelectedUser(
                          model.userNfToken!,
                          RemoteMessage(
                              notification: RemoteNotification(
                                  title: model.proName,
                                  body: 'Submited Final Document')));
                      Navigator.pop(context);
                      context
                          .read<BookedAppoinmentsBloc>()
                          .add(BookedAppointmentFetchEvent());
                    }
                  },
                  builder: (context, state) {
                    if (state is DocUploadLoadingState) {
                      return MyElevatedButton(
                        btName: '',
                        onTap: () {},
                        widget: const CircularProgressIndicator(
                          color: AppPalates.white,
                        ),
                      );
                    }
                    return MyElevatedButton(
                      btName: 'Upload Image',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (file != null) {
                            context.read<DocUploadBloc>().add(UploadCaDoc(
                                bookingModel: bookingTimeModel!,
                                docName: fileNameController.text.trim(),
                                files: file));
                          } else {
                            showSnackbar(context, 'Select All Document');
                          }
                        }
                      },
                    );
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
