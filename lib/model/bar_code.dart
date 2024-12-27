import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:accounting_app/Database/database_helper.dart';

class BarCode extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: databaseHelper.fetchVehicle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // 顯示載入中
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final vehicleData = snapshot.data!;
            final vehicleNumber = vehicleData['number'];

            return Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double screenWidth = constraints.maxWidth;
                    return BarcodeWidget(
                      data: vehicleNumber,
                      barcode: Barcode.code39(), // or other barcode type
                      width: screenWidth,
                      height: screenWidth / 4,
                      color: Colors.black,
                      backgroundColor: Colors.white,
                    );
                  },
                ),
              ],
            );
          } else {
            return Text('無載具資料');
          }
        },
      ),
    );
  }
}
