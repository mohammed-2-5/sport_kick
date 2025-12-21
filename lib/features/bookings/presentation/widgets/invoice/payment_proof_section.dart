import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/payment_proof_cubit.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Section for uploading and viewing payment proof.
class PaymentProofSection extends StatelessWidget {
  final BookingEntity booking;

  const PaymentProofSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentProofCubit, PaymentProofState>(
      builder: (context, state) {
        // If payment is verified, show success message
        if (booking.paymentStatus.isComplete) {
          return _VerifiedPaymentCard(booking: booking);
        }

        // If user is currently selecting/uploading, show that state first
        if (state is PaymentProofSelected) {
          return _SelectedProofCard(
            imageBytes: state.imageBytes,
            onUpload: () =>
                context.read<PaymentProofCubit>().uploadProof(booking.id),
            onCancel: () => context.read<PaymentProofCubit>().clearSelection(),
          );
        }

        if (state is PaymentProofUploading) {
          return const _UploadingCard();
        }

        // If upload was successful, show the existing proof card with updated booking
        if (state is PaymentProofSuccess) {
          return _ExistingPaymentProofCard(booking: state.updatedBooking);
        }

        // If payment proof is already uploaded (existing), show the proof
        if (booking.hasPaymentProof) {
          return _ExistingPaymentProofCard(booking: booking);
        }

        if (state is PaymentProofError) {
          return _UploadProofCard(
            errorMessage: state.message,
            onPickImage: () => _pickImage(context),
          );
        }

        // Default: show upload prompt
        return _UploadProofCard(onPickImage: () => _pickImage(context));
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    // Show bottom sheet to choose between camera and gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ImageSourceBottomSheet(),
    );

    if (!context.mounted || source == null) return;

    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (!context.mounted || pickedFile == null) return;

    // Read bytes from XFile (works on both web and mobile)
    final bytes = await pickedFile.readAsBytes();
    final fileName = pickedFile.name;

    if (!context.mounted) return;

    context.read<PaymentProofCubit>().selectImage(
      imageBytes: bytes,
      fileName: fileName,
    );
  }
}

/// Bottom sheet for selecting image source.
class _ImageSourceBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.selectPaymentProof,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.choosePaymentUploadMethod,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _SourceOption(
                icon: Icons.photo_camera_rounded,
                label: context.l10n.takePhoto,
                description: context.l10n.capturePaymentScreenshot,
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              const Divider(height: 1, indent: 70),
              _SourceOption(
                icon: Icons.photo_library_rounded,
                label: context.l10n.chooseFromGallery,
                description: context.l10n.selectExistingScreenshot,
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PremiumButton(
                  label: context.l10n.cancel,
                  onPressed: () => Navigator.pop(context),
                  style: PremiumButtonStyle.outline,
                  fullWidth: true,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.accentCyan, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Card prompting user to upload payment proof.
class _UploadProofCard extends StatelessWidget {
  final VoidCallback onPickImage;
  final String? errorMessage;

  const _UploadProofCard({required this.onPickImage, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.paymentProof,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Upload Area
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.3),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_rounded,
                      color: AppColors.accentCyan,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.uploadPaymentScreenshot,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.paymentUploadHint,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card showing selected image before upload.
class _SelectedProofCard extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onUpload;
  final VoidCallback onCancel;

  const _SelectedProofCard({
    required this.imageBytes,
    required this.onUpload,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.paymentProof,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Selected Image Preview using bytes (cross-platform)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              imageBytes,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: AppColors.backgroundLight,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: AppColors.textSecondary,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: context.l10n.change,
                  onPressed: onCancel,
                  style: PremiumButtonStyle.outline,
                  fullWidth: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: context.l10n.upload,
                  onPressed: onUpload,
                  icon: Icons.cloud_upload_rounded,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card showing upload in progress.
class _UploadingCard extends StatelessWidget {
  const _UploadingCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: AppColors.accentCyan,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.uploadingPaymentProof,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.paymentUploadWait,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Card showing existing payment proof (already uploaded).
class _ExistingPaymentProofCard extends StatelessWidget {
  final BookingEntity booking;

  const _ExistingPaymentProofCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.paymentProof,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.l10n.uploadedLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Image Preview
          GestureDetector(
            onTap: () => _showFullImage(context, booking.paymentProofUrl!),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    booking.paymentProofUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentCyan,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: AppColors.textSecondary,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.l10n.tapToView,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (booking.paymentUploadedAt != null) ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.uploadedOn(
                _formatDateTime(context, booking.paymentUploadedAt!),
              ),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(locale).format(dateTime);
    final time = DateFormat.Hm(locale).format(dateTime);
    return '$date $time';
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }
}

/// Full screen image viewer.
class _FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          context.l10n.paymentProof,
          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        ),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accentCyan),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Card showing verified payment proof.
class _VerifiedPaymentCard extends StatelessWidget {
  final BookingEntity booking;

  const _VerifiedPaymentCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: AppColors.success,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.paymentVerified,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.paymentVerifiedMessage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (booking.paymentVerifiedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.verifiedOn(
                _formatDate(context, booking.paymentVerifiedAt!),
              ),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(date);
  }
}
