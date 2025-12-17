import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/data/models/user_model.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';
import 'package:spo_kick/features/super_admin/data/models/city_model.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_statistics_model.dart';
import 'package:spo_kick/features/super_admin/data/repositories/super_admin_repository_impl.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late SuperAdminRepositoryImpl repository;
  late MockSuperAdminRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockSuperAdminRemoteDataSource();
    repository = SuperAdminRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('SuperAdminRepositoryImpl', () {
    const tServerException = ServerException('Server error');
    const tAuthenticationException = AuthenticationException('Auth error');

    group('getPlatformStatistics', () {
      const tStatisticsModel = PlatformStatisticsModel(
        totalUsers: 100,
        newUsersThisMonth: 10,
        totalAdmins: 5,
        activeFields: 20,
        totalFields: 25,
        citiesWithFields: 3,
        activeCities: 2,
        totalBookings: 500,
        pendingBookings: 50,
        confirmedBookings: 400,
        completedBookings: 350,
        canceledBookings: 50,
        manualBookings: 20,
        bookingsThisMonth: 100,
        totalRevenue: 10000.0,
        revenueThisMonth: 2000.0,
      );

      test(
        'should return PlatformStatisticsEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPlatformStatistics(),
          ).thenAnswer((_) async => tStatisticsModel);

          // Act
          final result = await repository.getPlatformStatistics();

          // Assert
          verify(() => mockRemoteDataSource.getPlatformStatistics()).called(1);
          expect(result, equals(const Right(tStatisticsModel)));
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPlatformStatistics(),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.getPlatformStatistics();

          // Assert
          verify(() => mockRemoteDataSource.getPlatformStatistics()).called(1);
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );

      test(
        'should return AuthenticationFailure when remote call throws AuthenticationException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPlatformStatistics(),
          ).thenThrow(tAuthenticationException);

          // Act
          final result = await repository.getPlatformStatistics();

          // Assert
          verify(() => mockRemoteDataSource.getPlatformStatistics()).called(1);
          expect(
            result,
            equals(
              Left(AuthenticationFailure(tAuthenticationException.message)),
            ),
          );
        },
      );
    });

    group('createAdminAccount', () {
      const tEmail = 'admin@test.com';
      const tFullName = 'Admin User';
      const tPhone = '1234567890';
      const tDefaultPassword = 'password123';
      final tInvitationModel = AdminInvitationModel(
        id: 'invitation1',
        email: tEmail,
        defaultPassword: tDefaultPassword,
        fullName: tFullName,
        phone: tPhone,
        createdBy: 'superadmin1',
        status: AdminInvitationStatus.pending,
        createdAt: DateTime.now(),
      );

      test(
        'should return AdminInvitationEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.createAdminAccount(
              email: tEmail,
              fullName: tFullName,
              phone: tPhone,
              defaultPassword: tDefaultPassword,
            ),
          ).thenAnswer((_) async => tInvitationModel);

          // Act
          final result = await repository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            phone: tPhone,
            defaultPassword: tDefaultPassword,
          );

          // Assert
          verify(
            () => mockRemoteDataSource.createAdminAccount(
              email: tEmail,
              fullName: tFullName,
              phone: tPhone,
              defaultPassword: tDefaultPassword,
            ),
          ).called(1);
          expect(result, equals(Right(tInvitationModel)));
        },
      );

      test(
        'should return ConflictFailure when remote call throws ConflictException',
        () async {
          // Arrange
          const tConflictException = ConflictException('Email exists');
          when(
            () => mockRemoteDataSource.createAdminAccount(
              email: tEmail,
              fullName: tFullName,
              phone: tPhone,
              defaultPassword: tDefaultPassword,
            ),
          ).thenThrow(tConflictException);

          // Act
          final result = await repository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            phone: tPhone,
            defaultPassword: tDefaultPassword,
          );

          // Assert
          expect(
            result,
            equals(Left(ConflictFailure(tConflictException.message))),
          );
        },
      );

      test(
        'should return ValidationFailure when remote call throws ValidationException',
        () async {
          // Arrange
          const tValidationException = ValidationException('Invalid email');
          when(
            () => mockRemoteDataSource.createAdminAccount(
              email: tEmail,
              fullName: tFullName,
              phone: tPhone,
              defaultPassword: tDefaultPassword,
            ),
          ).thenThrow(tValidationException);

          // Act
          final result = await repository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            phone: tPhone,
            defaultPassword: tDefaultPassword,
          );

          // Assert
          expect(
            result,
            equals(Left(ValidationFailure(tValidationException.message))),
          );
        },
      );
    });

    group('getAllAdmins', () {
      final tAdminsList = [
        UserModel(
          id: '1',
          email: 'admin1@test.com',
          fullName: 'Admin 1',
          role: 'admin',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      test(
        'should return list of UserEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllAdmins(),
          ).thenAnswer((_) async => tAdminsList);

          // Act
          final result = await repository.getAllAdmins();

          // Assert
          verify(() => mockRemoteDataSource.getAllAdmins()).called(1);
          expect(result.isRight(), true);
          result.fold(
            (l) => fail('Should be Right'),
            (r) => expect(r, equals(tAdminsList)),
          );
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllAdmins(),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.getAllAdmins();

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('getAllUsers', () {
      final tUsersList = [
        UserModel(
          id: '1',
          email: 'user1@test.com',
          fullName: 'User 1',
          role: 'user',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      test(
        'should return list of UserEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllUsers(),
          ).thenAnswer((_) async => tUsersList);

          // Act
          final result = await repository.getAllUsers();

          // Assert
          verify(() => mockRemoteDataSource.getAllUsers()).called(1);
          expect(result.isRight(), true);
          result.fold(
            (l) => fail('Should be Right'),
            (r) => expect(r, equals(tUsersList)),
          );
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllUsers(),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.getAllUsers();

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('assignFieldToAdmin', () {
      const tAdminId = 'admin1';
      const tFieldId = 'field1';
      const tNotes = 'Test notes';

      test(
        'should return void (Right(null)) when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.assignFieldToAdmin(
              adminId: tAdminId,
              fieldId: tFieldId,
              notes: tNotes,
            ),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.assignFieldToAdmin(
            adminId: tAdminId,
            fieldId: tFieldId,
            notes: tNotes,
          );

          // Assert
          verify(
            () => mockRemoteDataSource.assignFieldToAdmin(
              adminId: tAdminId,
              fieldId: tFieldId,
              notes: tNotes,
            ),
          ).called(1);
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should return NotFoundFailure when remote call throws NotFoundException',
        () async {
          // Arrange
          const tNotFoundException = NotFoundException(
            'Admin or field not found',
          );
          when(
            () => mockRemoteDataSource.assignFieldToAdmin(
              adminId: tAdminId,
              fieldId: tFieldId,
              notes: tNotes,
            ),
          ).thenThrow(tNotFoundException);

          // Act
          final result = await repository.assignFieldToAdmin(
            adminId: tAdminId,
            fieldId: tFieldId,
            notes: tNotes,
          );

          // Assert
          expect(
            result,
            equals(Left(NotFoundFailure(tNotFoundException.message))),
          );
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.assignFieldToAdmin(
              adminId: tAdminId,
              fieldId: tFieldId,
              notes: tNotes,
            ),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.assignFieldToAdmin(
            adminId: tAdminId,
            fieldId: tFieldId,
            notes: tNotes,
          );

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('getAllCities', () {
      final tCitiesList = [
        CityModel(
          id: '1',
          name: 'Cairo',
          isActive: true,
          fieldsCount: 5,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      test(
        'should return list of CityEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllCities(),
          ).thenAnswer((_) async => tCitiesList);

          // Act
          final result = await repository.getAllCities();

          // Assert
          verify(() => mockRemoteDataSource.getAllCities()).called(1);
          expect(result.isRight(), true);
          result.fold(
            (l) => fail('Should be Right'),
            (r) => expect(r, equals(tCitiesList)),
          );
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllCities(),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.getAllCities();

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('getActiveCities', () {
      final tCitiesList = [
        CityModel(
          id: '1',
          name: 'Cairo',
          isActive: true,
          fieldsCount: 5,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      test(
        'should return list of CityEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getActiveCities(),
          ).thenAnswer((_) async => tCitiesList);

          // Act
          final result = await repository.getActiveCities();

          // Assert
          verify(() => mockRemoteDataSource.getActiveCities()).called(1);
          expect(result.isRight(), true);
          result.fold(
            (l) => fail('Should be Right'),
            (r) => expect(r, equals(tCitiesList)),
          );
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getActiveCities(),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.getActiveCities();

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('deactivateUser', () {
      const tUserId = 'user1';

      test('should return void when remote call is successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.deactivateUser(tUserId),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.deactivateUser(tUserId);

        // Assert
        verify(() => mockRemoteDataSource.deactivateUser(tUserId)).called(1);
        expect(result, equals(const Right(null)));
      });

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.deactivateUser(tUserId),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.deactivateUser(tUserId);

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('activateUser', () {
      const tUserId = 'user1';

      test('should return void when remote call is successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.activateUser(tUserId),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.activateUser(tUserId);

        // Assert
        verify(() => mockRemoteDataSource.activateUser(tUserId)).called(1);
        expect(result, equals(const Right(null)));
      });

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.activateUser(tUserId),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.activateUser(tUserId);

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });

    group('createField', () {
      const tOwnerId = 'owner1';
      const tSportCategoryId = 'sport1';
      const tName = 'Field 1';
      const tAddress = 'Address 1';
      const tCity = 'Cairo';
      const tPrice = 100.0;
      final tFieldModel = FieldModel(
        id: 'field1',
        name: tName,
        sportCategoryId: tSportCategoryId,
        ownerId: tOwnerId,
        city: tCity,
        address: tAddress,
        pricePerHour: tPrice,
        currency: 'EGP',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test(
        'should return FieldEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.createField(
              ownerId: any(named: 'ownerId'),
              sportCategoryId: any(named: 'sportCategoryId'),
              name: any(named: 'name'),
              address: any(named: 'address'),
              city: any(named: 'city'),
              pricePerHour: any(named: 'pricePerHour'),
              description: any(named: 'description'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              currency: any(named: 'currency'),
              surfaceType: any(named: 'surfaceType'),
              capacity: any(named: 'capacity'),
              isIndoor: any(named: 'isIndoor'),
              images: any(named: 'images'),
              videoUrl: any(named: 'videoUrl'),
              facilities: any(named: 'facilities'),
              paymentPhone: any(named: 'paymentPhone'),
              paymentMethod: any(named: 'paymentMethod'),
            ),
          ).thenAnswer((_) async => tFieldModel);

          // Act
          final result = await repository.createField(
            ownerId: tOwnerId,
            sportCategoryId: tSportCategoryId,
            name: tName,
            address: tAddress,
            city: tCity,
            pricePerHour: tPrice,
          );

          // Assert
          verify(
            () => mockRemoteDataSource.createField(
              ownerId: tOwnerId,
              sportCategoryId: tSportCategoryId,
              name: tName,
              address: tAddress,
              city: tCity,
              pricePerHour: tPrice,
              currency: 'EGP',
              isIndoor: false,
              images: const [],
              facilities: const [],
            ),
          ).called(1);
          expect(result, equals(Right(tFieldModel)));
        },
      );

      test(
        'should return NotFoundFailure when remote call throws NotFoundException',
        () async {
          // Arrange
          const tNotFoundException = NotFoundException('City not found');
          when(
            () => mockRemoteDataSource.createField(
              ownerId: any(named: 'ownerId'),
              sportCategoryId: any(named: 'sportCategoryId'),
              name: any(named: 'name'),
              address: any(named: 'address'),
              city: any(named: 'city'),
              pricePerHour: any(named: 'pricePerHour'),
              description: any(named: 'description'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              currency: any(named: 'currency'),
              surfaceType: any(named: 'surfaceType'),
              capacity: any(named: 'capacity'),
              isIndoor: any(named: 'isIndoor'),
              images: any(named: 'images'),
              videoUrl: any(named: 'videoUrl'),
              facilities: any(named: 'facilities'),
              paymentPhone: any(named: 'paymentPhone'),
              paymentMethod: any(named: 'paymentMethod'),
            ),
          ).thenThrow(tNotFoundException);

          // Act
          final result = await repository.createField(
            ownerId: tOwnerId,
            sportCategoryId: tSportCategoryId,
            name: tName,
            address: tAddress,
            city: tCity,
            pricePerHour: tPrice,
          );

          // Assert
          expect(
            result,
            equals(Left(NotFoundFailure(tNotFoundException.message))),
          );
        },
      );

      test(
        'should return ConflictFailure when remote call throws ConflictException',
        () async {
          // Arrange
          const tConflictException = ConflictException('Field exists');
          when(
            () => mockRemoteDataSource.createField(
              ownerId: any(named: 'ownerId'),
              sportCategoryId: any(named: 'sportCategoryId'),
              name: any(named: 'name'),
              address: any(named: 'address'),
              city: any(named: 'city'),
              pricePerHour: any(named: 'pricePerHour'),
              description: any(named: 'description'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              currency: any(named: 'currency'),
              surfaceType: any(named: 'surfaceType'),
              capacity: any(named: 'capacity'),
              isIndoor: any(named: 'isIndoor'),
              images: any(named: 'images'),
              videoUrl: any(named: 'videoUrl'),
              facilities: any(named: 'facilities'),
              paymentPhone: any(named: 'paymentPhone'),
              paymentMethod: any(named: 'paymentMethod'),
            ),
          ).thenThrow(tConflictException);

          // Act
          final result = await repository.createField(
            ownerId: tOwnerId,
            sportCategoryId: tSportCategoryId,
            name: tName,
            address: tAddress,
            city: tCity,
            pricePerHour: tPrice,
          );

          // Assert
          expect(
            result,
            equals(Left(ConflictFailure(tConflictException.message))),
          );
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.createField(
              ownerId: any(named: 'ownerId'),
              sportCategoryId: any(named: 'sportCategoryId'),
              name: any(named: 'name'),
              address: any(named: 'address'),
              city: any(named: 'city'),
              pricePerHour: any(named: 'pricePerHour'),
              description: any(named: 'description'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              currency: any(named: 'currency'),
              surfaceType: any(named: 'surfaceType'),
              capacity: any(named: 'capacity'),
              isIndoor: any(named: 'isIndoor'),
              images: any(named: 'images'),
              videoUrl: any(named: 'videoUrl'),
              facilities: any(named: 'facilities'),
              paymentPhone: any(named: 'paymentPhone'),
              paymentMethod: any(named: 'paymentMethod'),
            ),
          ).thenThrow(tServerException);

          // Act
          final result = await repository.createField(
            ownerId: tOwnerId,
            sportCategoryId: tSportCategoryId,
            name: tName,
            address: tAddress,
            city: tCity,
            pricePerHour: tPrice,
          );

          // Assert
          expect(result, equals(Left(ServerFailure(tServerException.message))));
        },
      );
    });
  });
}
