// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';

class MyDropDownWidget extends StatefulWidget {
  MyDropDownWidget(
      {super.key,
      required this.myDropDown,
required this.selected,
      required this.textEditingController,
       this.elevation});
  List<String> myDropDown;
  TextEditingController textEditingController;
  double? elevation;
  Function(String?)? selected;

  @override
  State<MyDropDownWidget> createState() => _MyDropDownWidgetState();
}

class _MyDropDownWidgetState extends State<MyDropDownWidget> {
  @override
  Widget build(BuildContext context) {

    return MyCardWidget(
      elevation: widget.elevation ?? 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: DropdownMenu(
            inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.all(5),
                floatingLabelStyle: TextField.materialMisspelledTextStyle,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12))),
            menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(AppPalates.white),
                surfaceTintColor: MaterialStatePropertyAll(AppPalates.white),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.all(10),
                )),
            controller: widget.textEditingController,
            initialSelection: widget.myDropDown[0],
            onSelected:widget.selected,
          
            dropdownMenuEntries: widget.myDropDown
                .map(
                  (e) => DropdownMenuEntry(
                    value: e,
                    label: e,
                  ),
                )
                .toList()),
      ),
    );
  }
}
