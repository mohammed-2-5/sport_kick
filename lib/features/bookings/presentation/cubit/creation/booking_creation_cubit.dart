import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_manual_booking_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/creation/booking_creation_state.dart';

/// Cubit for managing booking creation state.
///
/// Handles booking creation operations:
/// - Creating regular bookings
/// - Creating manual bookings (for field owners/admins)
/// - Creating bookings from time slot selection
class BookingCreationCubit extends Cubit<BookingCreationState> {
  final CreateBookingUseCase createBookingUseCase;
  final CreateManualBookingUseCase createManualBookingUseCase;

  BookingCreationCubit({
    required this.createBookingUseCase,
    required this.createManualBookingUseCase,
  }) : super(const BookingCreationInitial());

  /// Create a booking using provided time slot selection.
  ///
  /// This method accepts the selected field, date, and time slot data
  /// as parameters instead of accessing internal state.
  Future<void> createBookingFromSelection({
    required String fieldId,
    required DateTime selectedDate,
    required String startTime,
    required String endTime,
    required double totalPrice,
    required String loadingMessage,
  }) async {
    await createBooking(
      fieldId: fieldId,
      date: selectedDate,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      notes: null,
      loadingMessage: loadingMessage,
    );
  }

  /// Create a new booking.
  Future<void> createBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    String? notes,
    required String loadingMessage,
  }) async {
    emit(BookingCreationLoading(message: loadingMessage));

    final result = await createBookingUseCase(
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      notes: notes,
    );

    result.fold((failure) {
      debugPrint(
        '❌ ERROR [BookingCreationCubit.createBooking]: ${failure.message}',
      );
      emit(BookingCreationError(failure.message));
    }, (booking) => emit(BookingCreated(booking)));
  }

  /// Create a manual booking (for field owners/admins).
  ///
  /// Manual bookings are created by admins for walk-in customers.
  /// They are automatically confirmed and include customer information.
  Future<void> createManualBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? notes,
    required String loadingMessage,
  }) async {
    debugPrint('🔄 [BookingCreationCubit] Creating manual booking...');
    debugPrint('   Customer: $customerName ($customerPhone)');
    debugPrint('   Field: $fieldId, Date: $date, Time: $startTime-$endTime');

    emit(BookingCreationLoading(message: loadingMessage));

    final result = await createManualBookingUseCase(
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      notes: notes,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ ERROR [BookingCreationCubit.createManualBooking]: ${failure.message}',
        );
        emit(BookingCreationError(failure.message));
      },
      (booking) {
        debugPrint(
          '✅ [BookingCreationCubit] Manual booking created: ${booking.id}',
        );
        emit(BookingCreated(booking));
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    emit(const BookingCreationInitial());
  }
}
