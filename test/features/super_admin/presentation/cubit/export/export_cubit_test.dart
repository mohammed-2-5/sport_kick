import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/services/csv_export_service.dart';
import 'package:spo_kick/core/services/pdf_export_service.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/export/export_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/export/export_state.dart';

// Mock Services
class MockCsvExportService extends Mock implements CsvExportService {}

class MockPdfExportService extends Mock implements PdfExportService {}

// Fake for fallback
class FakePlatformStatisticsEntity extends Fake
    implements PlatformStatisticsEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePlatformStatisticsEntity());
  });

  late ExportCubit cubit;
  late MockCsvExportService mockCsvExport;
  late MockPdfExportService mockPdfExport;

  // Test data
  final now = DateTime.now();
  final testUser = UserEntity(
    id: 'user-1',
    email: 'user@test.com',
    fullName: 'Test User',
    role: 'user',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final testStats = PlatformStatisticsEntity(
    totalUsers: 100,
    newUsersThisMonth: 20,
    totalAdmins: 10,
    activeFields: 40,
    totalFields: 50,
    citiesWithFields: 8,
    activeCities: 10,
    totalBookings: 500,
    pendingBookings: 50,
    confirmedBookings: 200,
    completedBookings: 200,
    canceledBookings: 50,
    manualBookings: 100,
    bookingsThisMonth: 100,
    totalRevenue: 50000.0,
    revenueThisMonth: 5000.0,
  );

  setUp(() {
    mockCsvExport = MockCsvExportService();
    mockPdfExport = MockPdfExportService();

    cubit = ExportCubit(
      csvExportService: mockCsvExport,
      pdfExportService: mockPdfExport,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ExportCubit', () {
    test('initial state is ExportInitial', () {
      expect(cubit.state, const ExportInitial());
    });
  });

  group('exportUsersToCSV', () {
    blocTest<ExportCubit, ExportState>(
      'emits ExportSuccess when export succeeds',
      build: () {
        when(
          () => mockCsvExport.exportUsersToCsv(any(), any()),
        ).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.exportUsersToCSV([testUser]),
      expect: () => [
        isA<ExportSuccess>().having(
          (s) => s.message,
          'message',
          'Users exported successfully',
        ),
      ],
    );

    blocTest<ExportCubit, ExportState>(
      'emits ExportError when export fails',
      build: () {
        when(
          () => mockCsvExport.exportUsersToCsv(any(), any()),
        ).thenThrow(Exception('Export failed'));
        return cubit;
      },
      act: (cubit) => cubit.exportUsersToCSV([testUser]),
      expect: () => [
        isA<ExportError>().having(
          (s) => s.message,
          'message',
          contains('Export failed'),
        ),
      ],
    );
  });

  group('exportAdminsToCSV', () {
    blocTest<ExportCubit, ExportState>(
      'emits ExportSuccess when export succeeds',
      build: () {
        when(
          () => mockCsvExport.exportUsersToCsv(any(), any()),
        ).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.exportAdminsToCSV([testUser]),
      expect: () => [
        isA<ExportSuccess>().having(
          (s) => s.message,
          'message',
          'Admins exported successfully',
        ),
      ],
    );

    blocTest<ExportCubit, ExportState>(
      'emits ExportError when export fails',
      build: () {
        when(
          () => mockCsvExport.exportUsersToCsv(any(), any()),
        ).thenThrow(Exception('Export failed'));
        return cubit;
      },
      act: (cubit) => cubit.exportAdminsToCSV([testUser]),
      expect: () => [
        isA<ExportError>().having(
          (s) => s.message,
          'message',
          contains('Export failed'),
        ),
      ],
    );
  });

  group('exportPlatformStatisticsToPDF', () {
    blocTest<ExportCubit, ExportState>(
      'emits ExportSuccess when export succeeds',
      build: () {
        when(
          () => mockPdfExport.exportPlatformStatisticsToPdf(any()),
        ).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.exportPlatformStatisticsToPDF(testStats),
      expect: () => [
        isA<ExportSuccess>().having(
          (s) => s.message,
          'message',
          'Statistics exported successfully',
        ),
      ],
    );

    blocTest<ExportCubit, ExportState>(
      'emits ExportError when export fails',
      build: () {
        when(
          () => mockPdfExport.exportPlatformStatisticsToPdf(any()),
        ).thenThrow(Exception('Export failed'));
        return cubit;
      },
      act: (cubit) => cubit.exportPlatformStatisticsToPDF(testStats),
      expect: () => [
        isA<ExportError>().having(
          (s) => s.message,
          'message',
          contains('Export failed'),
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<ExportCubit, ExportState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const ExportSuccess('Success'),
      act: (cubit) => cubit.reset(),
      expect: () => [const ExportInitial()],
    );
  });
}
