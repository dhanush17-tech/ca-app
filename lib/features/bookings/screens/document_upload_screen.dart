
import 'dart:io';

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/core/push_notification_service.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/snack_bar.dart';
import 'package:ca_appoinment/features/user/blocs/booked_appointment_bloc/booked_appoinments_bloc.dart';
import 'package:ca_appoinment/features/bookings/blocs/doc_upload_bloc/doc_upload_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/widgets/file_pick_container.dart';

class DocUploadScreen extends StatefulWidget {
  const DocUploadScreen({super.key});

  @override
  State<DocUploadScreen> createState() => _DocUploadScreenState();
}

class _DocUploadScreenState extends State<DocUploadScreen> {
  var docNameContoller = TextEditingController();
  File? aadhaarFile;
  File? panFile;
  File? bankFile;
  BookingTimeModel? bookingTimeModel;
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilePickContainer(
                  aadhaarFile: aadhaarFile,
                  title: 'Aadhar Card',
                  ontap: () async {
                    var selectImage = await  getImage();
                    if (selectImage != null) {
                      setState(() {
                        aadhaarFile = File(selectImage.path);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                FilePickContainer(
                  aadhaarFile: panFile,
                  title: 'Pan Card',
                  ontap: () async {
                    var selectImage = await getImage();
                    if (selectImage != null) {
                      setState(() {
                        panFile = File(selectImage.path);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                FilePickContainer(
                  aadhaarFile: bankFile,
                  title: 'Bank statement',
                  ontap: () async {
                    var selectImage = await  getImage();
                    if (selectImage != null) {
                      setState(() {
                        bankFile = File(selectImage.path);
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
                            model.proNfToken!,
                            RemoteMessage(
                                notification: RemoteNotification(
                                    title: model.userName,
                                    body: 'Uploaded Document')));
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
                          if (aadhaarFile != null &&
                              bankFile != null &&
                              bankFile != null) {
                            context.read<DocUploadBloc>().add(UploadUserDoc(
                                bookingModel: bookingTimeModel!,
                                aadhaarCard: aadhaarFile,
                                bankStatements: bankFile,
                                panCard: panFile));
                          } else {
                            showSnackbar(context, 'Select All Document');
                          }
                        },
                      );
                    },
                  ),
                )
              ]),
        ),
      ),
    );
  }

  OutlineInputBorder myOutlineborder() {
    return OutlineInputBorder(
        borderSide: const BorderSide(color: AppPalates.black, width: 2),
        borderRadius: BorderRadius.circular(12));
  }
}

Future<File?> getImage() async {
  File? pickedImage;
  var selectImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (selectImage != null) {
    pickedImage = File(selectImage.path);
  }
  return pickedImage;
}
