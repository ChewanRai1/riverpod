import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/app/app.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

