import 'package:flutter/material.dart';

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= 600;
