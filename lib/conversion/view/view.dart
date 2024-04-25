import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../conversion.dart';

class ConversionView extends StatelessWidget {
  const ConversionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ConversionSettingsCubit(),
        child: ConversionSettingsWidget(),
      ),
    );
  }
}
