import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/widgets/premium/premium_search_bar.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_switcher_button.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/search_cubit.dart';
import 'package:spo_kick/features/fields/presentation/utils/city_helper.dart';

import '../widgets/search/search_content.dart';

/// Search page for finding fields by name, city, or address.
///
/// Uses [SearchCubit] for all business logic.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityState = context.read<CityCubit>().state;
    final initialCityId = CityHelper.getCurrentCityId(cityState);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final fieldsCubit = sl<FieldsCubit>();
            if (initialCityId != null) {
              fieldsCubit.setCurrentCity(initialCityId);
            }
            return fieldsCubit;
          },
        ),
        BlocProvider(
          create: (context) =>
              SearchCubit(fieldsCubit: context.read<FieldsCubit>())
                ..loadHistory(),
        ),
      ],
      child: BlocListener<CityCubit, CityState>(
        listener: (context, state) {
          if (state is CitySelected) {
            context.read<SearchCubit>().onCityChanged(state.city.id);
          } else if (state is CitySaved) {
            context.read<SearchCubit>().onCityChanged(state.city.id);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: Column(
            children: [
              PremiumCurvedHeader(
                title: 'Search Fields',
                showBackButton: true,
                height: 200,
                trailing: const CitySwitcherButton(),
                bottom: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Builder(
                    builder: (context) => PremiumSearchBar(
                      hint: 'Search by name, city, or address...',
                      controller: _searchController,
                      onChanged: (query) {
                        context.read<SearchCubit>().search(query);
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SearchContent(searchController: _searchController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
