import 'package:flutter/material.dart';
import '../helpers/financial_string_formart.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool currency;
  final double fontSize;
  final Color color;
  const InfoCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.currency,
      required this.fontSize,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: color,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.isEmpty
                        ? '0'
                        : value.formatToFinancial(isMoneySymbol: currency),
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: ''),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 10),
                    textDirection: TextDirection.ltr,
                  )
                ],
              )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon),
              ),
            ),
          )
        ],
      ),
    );
  }
}
