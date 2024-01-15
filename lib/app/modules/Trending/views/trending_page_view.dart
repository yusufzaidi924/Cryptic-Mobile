import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edmonscan/app/modules/Trending/controllers/trending_page_controller.dart';
import 'package:edmonscan/config/theme/dark_theme_colors.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/app_assets.dart';
import 'package:edmonscan/utils/app_styles.dart';
import 'package:edmonscan/utils/crypto_static_value.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class TrendingPageView extends GetView<TrendingPageController> {
  const TrendingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrendingPageController>(
        init: TrendingPageController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: Colors.white,
              title: const Text(
                'Trending',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF23233F),
                  fontSize: 24,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    AppAssets.exportIcon,
                  ),
                )
              ],
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios,
                    color: LightThemeColors.primaryColor),
              ),
              centerTitle: true,
              // elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(16),
                    color: LightThemeColors.backgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: IncomWidget(
                              icon: AppAssets.upIcon,
                              title: "Income",
                              value: "\$78.3",
                              isIncome: true),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: IncomWidget(
                              icon: AppAssets.upIcon,
                              title: "Outcome",
                              value: "\$77.3",
                              isIncome: true),
                        ),
                      ],
                    ),
                  ),
                  BarChartWidget(points: pricePoints),
                  SizedBox(
                    height: 8,
                  ),
                  CurrentPriceOfCrypto(
                    controller: controller,
                  )
                ],
              ),
            ),
          );
        });
  }
}

class IncomWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final bool isIncome;
  const IncomWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.value,
      required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: LightThemeColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xff3D576F).withOpacity(0.1),
            spreadRadius: -2,
            blurRadius: 12,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 35,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isIncome
                  ? Color(0xff3DAB25).withOpacity(0.2)
                  : Color(0xffEB5A5A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: AppStyles.textSize20(
                  color: Color(0xff6E6E82),
                ),
              ),
              Text(
                "$value",
                style: AppStyles.textSize26(
                  fontWeight: FontWeight.w700,
                  color: isIncome ? Color(0xff3DAB25) : Color(0xffEB5A5A),
                ).copyWith(fontSize: 28),
              )
            ],
          )
        ],
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<PricePoint> points;

  @override
  State<BarChartWidget> createState() =>
      _BarChartWidgetState(points: this.points);
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<PricePoint> points;

  _BarChartWidgetState({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: LightThemeColors.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                LabelFilterChart(
                  isSelected: true,
                  title: "The last 7 days",
                ),
                LabelFilterChart(
                  isSelected: false,
                  title: "30 days",
                ),
                LabelFilterChart(
                  isSelected: false,
                  title: "Custom",
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                backgroundColor: LightThemeColors.backgroundColor,
                barGroups: _chartGroups(),
                borderData: FlBorderData(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                gridData: FlGridData(
                  show: true, drawVerticalLine: false,
                  horizontalInterval: 150,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      strokeWidth: 0.2,
                    );
                  },
                  // checkToShowHorizontalLine: true,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        "${value.toInt()}",
                        style: AppStyles.textSize12(
                            color: Color(
                          0xff7F7F92,
                        )),
                      );
                    },
                  )),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    return points.map((point) {
      final double y = (Random().nextBool() ? 1 : -1) * point.y;
      return BarChartGroupData(x: point.x.toInt(), barRods: [
        BarChartRodData(
          toY: y,
          borderRadius: BorderRadius.circular(0),
          width: 30,
          color: y > 0 ? Color(0xff3DAB25) : Color(0xffEB5A5A),
        )
      ]);
    }).toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        // reservedSize: 40,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 0:
              text = '11-12';
              break;
            case 1:
              text = '';
              break;
            case 2:
              text = '';
              break;
            case 3:
              text = '';
              break;
            case 4:
              text = '';
              break;
            case 6:
              text = '17-12';
              break;
          }

          return Text(
            text,
            style: AppStyles.textSize12(
                color: Color(
              0xff7F7F92,
            )),
          );
        },
      );
}

class LabelFilterChart extends StatelessWidget {
  final String title;
  final bool isSelected;
  const LabelFilterChart(
      {super.key, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Color(0xff665AF0) : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(7),
        color:
            isSelected ? Color(0xff665AF0).withOpacity(0.1) : Color(0xffE5E5E5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        title,
        style: AppStyles.textSize14(),
      ),
    );
  }
}

class CurrentPriceOfCrypto extends StatelessWidget {
  final TrendingPageController controller;
  const CurrentPriceOfCrypto({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_) {
      if (controller.isGetCryptoLoading) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: LightThemeColors.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Current Price Of Cryptocurrency",
                style: AppStyles.textSize18(fontWeight: FontWeight.w700),
              ),
            ),
            Column(
              children: List.generate(controller.listCrypto.length, (index) {
                var item = controller.listCrypto[index];
                var i = (cryptoStaticValues['data'] as List)
                    .indexWhere((element) => element['id'] == item.id);
                if (i != -1) {
                  var data = (cryptoStaticValues['data'] as List)[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                color: Colors.grey[300],
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://s2.coinmarketcap.com/static/img/coins/64x64/${item.id}.png",
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['symbol']}",
                                  style: AppStyles.textSize16(),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${item.quote?.usd?.percentChange24h?.toStringAsFixed(5)}",
                                style: AppStyles.textSize16(
                                    color: Color(0xff3DAB25)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Last update: ${DateFormat("MM-dd hh:mm a").format(DateTime.parse(item.quote!.usd!.lastUpdated!))}",
                                  style: AppStyles.textSize14(
                                    color: Color(0xff6E6E82),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  );
                }
                return Container();
              }),
            ),
          ],
        ),
      );
    });
  }
}

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  final randomNumbers = <double>[];

  for (var i = 0; i < 7; i++) {
    int number = random.nextInt(301) + 100;
    randomNumbers.add(number.toDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}
