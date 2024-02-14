import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class ChartScreen extends StatefulWidget {
  final double? tireCost;
  final double? serviceCost;
  final double? insCost;
  final double? foodCost;
  final double? roomCost;
  final double? otherCost;
  final double totalFuelCost;

  const ChartScreen(
      {super.key,
      this.tireCost,
      required this.totalFuelCost,
      this.serviceCost,
      this.insCost,
      this.foodCost,
      this.roomCost,
      this.otherCost});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int touchedIndex = -1;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Graphical view"),
        actions: [
          GestureDetector(
              onTap: () async {
                try {
                  Uint8List? image = await screenshotController.capture();
                  setState(() {
                    _imageFile = image;
                  });

                  if (_imageFile == null) {
                    return;
                  }

                  await ImageGallerySaver.saveImage(_imageFile!,
                      name: 'image_${widget.serviceCost}');
                } catch (error) {
                  print(error);
                }
              },
              child: Icon(Iconsax.send_2)),
          SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            children: [
              const Spacer(),

              Expanded(
                child: Transform.scale(
                  scale: 1.3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Adjust the spacing as needed
              // Add the legend
              const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Indicator(
                    color: AppColors.contentColorBlue,
                    text: 'Fuel Cost',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorYellow,
                    text: 'Service Cost',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorPurple,
                    text: 'Insurance Cost',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Colors.redAccent,
                    text: 'Accommodation Cost',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorGreen,
                    text: 'Food Cost',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorBlack,
                    text: 'Other',
                    isSquare: true,
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double totalCost = widget.totalFuelCost +
        (widget.tireCost ?? 0) +
        (widget.serviceCost ?? 0) +
        (widget.insCost ?? 0) +
        (widget.foodCost ?? 0) +
        (widget.roomCost ?? 0) +
        (widget.otherCost ?? 0);

    print(((widget.roomCost ?? 0) / totalCost) * 100.toDouble());

    setState(() {});

    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 9.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: (widget.totalFuelCost / totalCost) * 100.toDouble(),
            title: "${((widget.totalFuelCost / totalCost) * 100).floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            showTitle: true,
            color: AppColors.contentColorYellow,
            value: ((widget.serviceCost ?? 0) / totalCost) * 100.toDouble(),
            title:
                "${(((widget.serviceCost ?? 0) / totalCost) * 100).floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: ((widget.insCost ?? 0) / totalCost) * 100.toDouble(),
            title: "${(((widget.insCost ?? 0) / totalCost) * 100).floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: ((widget.foodCost ?? 0) / totalCost) * 100.toDouble(),
            title: "${(((widget.foodCost ?? 0) / totalCost) * 100).floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: ((widget.roomCost ?? 0) / totalCost) * 100.toDouble(),
            title:
                "${(((widget.roomCost ?? 0) / totalCost) * 100).toInt().floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: AppColors.contentColorBlack,
            value: ((widget.otherCost ?? 0) / totalCost) * 100.toDouble(),
            title:
                "${(((widget.otherCost ?? 0) / totalCost) * 100).toInt().floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 6:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: ((widget.tireCost ?? 0) / totalCost) * 100.toDouble(),
            title: "${(((widget.tireCost ?? 0) / totalCost) * 100).floor()}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static Color contentColorPink = Colors.redAccent;
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
