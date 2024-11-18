import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientInfoScreen extends StatelessWidget {
  const ClientInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const Padding(
          padding: EdgeInsets.all(3.0),
          child: MyIconPopButton(),
        ),
        title: Text(model.name!),
      ),
      body: Center(
        child: Column(
          children: [
            UserProfilePic(url: model.profilePic),
            const SizedBox(height: 15),
            Text(
              model.name!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppPalates.black,
                  fontSize: 17),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email : ${model.email!}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppPalates.black,
                      fontSize: 15),
                ),
                if (model.number != null) const SizedBox(height: 10),
                if (model.number != null)
                  Text(
                    'Number : ${model.number!.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppPalates.black,
                        fontSize: 15),
                  ),
                if (model.gender != null) const SizedBox(height: 10),
                if (model.gender != null)
                  Text('Gender : ${model.gender}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppPalates.black,
                          fontSize: 15)),
                if (model.bithDate != null) const SizedBox(height: 10),
                if (model.bithDate != null)
                  Text(
                      'Birth Date : ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(model.bithDate!)))}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppPalates.black,
                          fontSize: 15)),
                if (model.accountCreatedDate != null)
                  const SizedBox(height: 10),
                if (model.accountCreatedDate != null)
                  const Text('Register At :-',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppPalates.black,
                          fontSize: 15)),
                if (model.accountCreatedDate != null) const SizedBox(width: 10),
                if (model.accountCreatedDate != null)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          DateFormat('hh : MM : aa MMMM d,yyyy ').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(model.accountCreatedDate!))),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppPalates.black,
                              fontSize: 15)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
