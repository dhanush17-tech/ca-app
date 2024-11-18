// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';

class ProfeessionalAccountLoaderState extends StatelessWidget {
  const ProfeessionalAccountLoaderState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return MyCardWidget(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: AppPalates.white,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppPalates.greyShade100,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 22,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppPalates.greyShade100,
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  height: 22,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppPalates.greyShade100,
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  height: 22,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: AppPalates.greyShade100,
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Expanded(
                                child: MyElevatedButton(
                                    bgColor: AppPalates.primary.withOpacity(.7),
                                    btName: ' ',
                                    onTap: () {})),
                            const SizedBox(width: 15),
                            Expanded(
                                child: MyElevatedButton(
                                    bgColor: AppPalates.greyShade100,
                                    btName: ' ',
                                    onTap: () {})),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
