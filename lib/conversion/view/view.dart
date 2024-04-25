import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../conversion.dart';

class ConversionView extends StatelessWidget {
  const ConversionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ConversionSettingsCubit>(create: (_) => ConversionSettingsCubit()),
          BlocProvider<ConversionBloc>(create: (_) => ConversionBloc()),
        ],
        child: const ConversionViewContent(),
      ),
    );
  }
}

/// Displays the conversion settings and the state of the conversion.
class ConversionViewContent extends StatelessWidget {
  const ConversionViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ConversionSettingsWidget(
        onConversionPressed: () => _onConversionPressed(
          conversionBloc: context.read<ConversionBloc>(),
          settings: context.read<ConversionSettingsCubit>(),
        ),
      ),
      const ConversionStateWidget(),
    ]);
  }

  void _onConversionPressed({
    required ConversionBloc conversionBloc,
    required ConversionSettingsCubit settings,
  }) {
    conversionBloc.add(StartConversionEvent(settings: settings.state));
  }
}
