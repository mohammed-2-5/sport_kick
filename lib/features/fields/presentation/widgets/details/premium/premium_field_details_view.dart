import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/field_details_back_button.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/field_details_content.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/field_details_floating_header_builder.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/premium_field_gallery_viewer.dart';

/// Premium field details view with all enhanced components.
///
/// Features:
/// - Hero image with parallax
/// - Floating glassmorphism header on scroll
/// - Premium cards for all sections
/// - Image gallery viewer with zoom
/// - Floating book now button
class PremiumFieldDetailsView extends StatefulWidget {
  final FieldEntity field;
  final dynamic category;

  const PremiumFieldDetailsView({
    super.key,
    required this.field,
    this.category,
  });

  @override
  State<PremiumFieldDetailsView> createState() =>
      _PremiumFieldDetailsViewState();
}

class _PremiumFieldDetailsViewState extends State<PremiumFieldDetailsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      context.read<FieldDetailsScrollCubit>().updateScroll(
        _scrollController.offset,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          FieldDetailsContent(
            field: widget.field,
            category: widget.category,
            onImageTap: () {
              if (widget.field.images.isEmpty) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => PremiumFieldGalleryViewer(
                    images: widget.field.images,
                    initialIndex: 0,
                  ),
                ),
              );
            },
            scrollController: _scrollController,
          ),
          FieldDetailsFloatingHeaderBuilder(field: widget.field),
          const FieldDetailsBackButton(),
        ],
      ),
    );
  }
}
