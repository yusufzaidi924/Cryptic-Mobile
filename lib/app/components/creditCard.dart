import 'package:flutter/material.dart';

CreditCard({
  required String cardNumber,
  required String holderName,
  required String expDate,
  String? cardType,
  Color? backgroundColor,
  double? width,
  double? height,
}) {
  return Container(
      width: width ?? double.infinity,
      height: height ?? 180,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: ShapeDecoration(
        color: backgroundColor ?? Color(0xFF655AF0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/card_back.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // CARD TYPE
              Text(
                cardType ?? 'CREDIT CARD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),

              // CARD NUMBER
              Text(
                '****  ****  **** ${cardNumber.substring(cardNumber.length - 4)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CARD HOLDER NAME
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Name',
                    style: TextStyle(
                      color: Color(0xFFEEEFF3),
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 2.5,
                    ),
                  ),
                  Text(
                    '${holderName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  )
                ],
              ),
              // EXP DATE
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXP',
                    style: TextStyle(
                      color: Color(0xFFEEEFF3),
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 2.5,
                    ),
                  ),
                  Text(
                    '${expDate}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  )
                ],
              ),
              // CARD_SIM
              Container(
                width: 45,
                height: 35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/card_sim.png'),
                  ),
                ),
              ),
            ],
          )
        ],
      ));
}
