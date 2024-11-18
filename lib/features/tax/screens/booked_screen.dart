//
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class BookingSuccesDialog extends StatelessWidget {
  const BookingSuccesDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      backgroundColor: AppPalates.primary,
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Appoinment Booked',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppPalates.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppPalates.white)),
                    child: const SizedBox(
                      width: 280,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Meeting Start On Selected Time',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppPalates.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                style: IconButton.styleFrom(
                    backgroundColor: AppPalates.white,
                    padding: const EdgeInsets.all(0)),
                icon: const Icon(
                  Icons.cancel,
                  size: 40,
                  color: AppPalates.black,
                )),
          )
        ],
      ),
    );
  }
}
