import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selector_dialog.dart';

class CitySelectorLauncher {
  CitySelectorLauncher._();

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CityCubit>(),
        child: const CitySelectorDialog(),
      ),
    );
  }
}
