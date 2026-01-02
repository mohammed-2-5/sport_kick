import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/field_details_back_button.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/field_details_content.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/field_details_floating_actions.dart';
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    context.read<FieldDetailsScrollCubit>().updateScroll(
      _scrollController.offset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main scrollable content
          FieldDetailsContent(
            field: widget.field,
            category: widget.category,
            onImageTap: _showGalleryViewer,
            scrollController: _scrollController,
          ),

          // Floating header (appears on scroll)
          FieldDetailsFloatingHeaderBuilder(field: widget.field),

          // Back button (visible when header is hidden)
          const FieldDetailsBackButton(),

          // Floating book now buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FieldDetailsFloatingActions(field: widget.field),
          ),
        ],
      ),
    );
  }

  void _showGalleryViewer() {
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
  }
}
