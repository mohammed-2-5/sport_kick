import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/fields/data/models/sport_category_model.dart';
import 'package:spo_kick/features/fields/data/repositories/field_repository_impl.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late FieldRepositoryImpl repository;
  late MockFieldRemoteDataSource mockRemoteDataSource;

  final now = DateTime.now();

  // Test Data
  final tFieldModel = FieldModel(
    id: 'field-1',
    name: 'Test Field',
    sportCategoryId: 'cat-1',
    ownerId: 'owner-1',
    city: 'Cairo',
    address: '123 Test St',
    pricePerHour: 100.0,
    currency: 'EGP',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final FieldEntity tFieldEntity = tFieldModel;
  final List<FieldModel> tFieldModels = [tFieldModel];
  final List<FieldEntity> tFieldEntities = [tFieldEntity];

  final tCategoryModel = SportCategoryModel(
    id: 'cat-1',
    name: 'Football',
    icon: 'football.png',
    isActive: true,
    createdAt: now,
  );

  final SportCategoryEntity tCategoryEntity = tCategoryModel;
  final List<SportCategoryModel> tCategoryModels = [tCategoryModel];
  final List<SportCategoryEntity> tCategoryEntities = [tCategoryEntity];

  setUp(() {
    mockRemoteDataSource = MockFieldRemoteDataSource();
    repository = FieldRepositoryImpl(mockRemoteDataSource);
  });

  group('FieldRepositoryImpl -', () {
    group('getAllFields -', () {
      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllFields(),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.getAllFields();

          // Assert
          verify(() => mockRemoteDataSource.getAllFields()).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllFields(),
          ).thenThrow(const ServerException('Server Error'));

          // Act
          final result = await repository.getAllFields();

          // Assert
          verify(() => mockRemoteDataSource.getAllFields()).called(1);
          expect(result, equals(const Left(ServerFailure('Server Error'))));
        },
      );
    });

    group('getFieldById -', () {
      const tFieldId = 'field-1';

      test(
        'should return field when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getFieldById(tFieldId),
          ).thenAnswer((_) async => tFieldModel);

          // Act
          final result = await repository.getFieldById(tFieldId);

          // Assert
          verify(() => mockRemoteDataSource.getFieldById(tFieldId)).called(1);
          expect(result, equals(Right(tFieldEntity)));
        },
      );

      test(
        'should return NotFoundFailure when remote data source throws NotFoundException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getFieldById(tFieldId),
          ).thenThrow(const NotFoundException('Field not found'));

          // Act
          final result = await repository.getFieldById(tFieldId);

          // Assert
          verify(() => mockRemoteDataSource.getFieldById(tFieldId)).called(1);
          expect(result, equals(const Left(NotFoundFailure('Field not found'))));
        },
      );
    });

    group('searchFields -', () {
      const tQuery = 'Test';

      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.searchFields(tQuery),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.searchFields(tQuery);

          // Assert
          verify(() => mockRemoteDataSource.searchFields(tQuery)).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );
    });

    group('getFieldsByCategory -', () {
      const tCategoryId = 'cat-1';

      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getFieldsByCategory(tCategoryId),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.getFieldsByCategory(tCategoryId);

          // Assert
          verify(
            () => mockRemoteDataSource.getFieldsByCategory(tCategoryId),
          ).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );
    });

    group('getFieldsByCity -', () {
      const tCity = 'Cairo';

      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getFieldsByCity(tCity),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.getFieldsByCity(tCity);

          // Assert
          verify(() => mockRemoteDataSource.getFieldsByCity(tCity)).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );
    });

    group('getFeaturedFields -', () {
      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getFeaturedFields(),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.getFeaturedFields();

          // Assert
          verify(() => mockRemoteDataSource.getFeaturedFields()).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );
    });

    group('getPopularFields -', () {
      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPopularFields(limit: 10),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.getPopularFields();

          // Assert
          verify(
            () => mockRemoteDataSource.getPopularFields(limit: 10),
          ).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );
    });

    group('getSportCategories -', () {
      test(
        'should return list of categories when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getSportCategories(),
          ).thenAnswer((_) async => tCategoryModels);

          // Act
          final result = await repository.getSportCategories();

          // Assert
          verify(() => mockRemoteDataSource.getSportCategories()).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tCategoryEntities));
        },
      );
    });

    group('filterFields -', () {
      test(
        'should return list of fields when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.filterFields(
              categoryId: any(named: 'categoryId'),
              city: any(named: 'city'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              amenities: any(named: 'amenities'),
            ),
          ).thenAnswer((_) async => tFieldModels);

          // Act
          final result = await repository.filterFields(
            categoryId: 'cat-1',
            city: 'Cairo',
          );

          // Assert
          verify(
            () => mockRemoteDataSource.filterFields(
              categoryId: 'cat-1',
              city: 'Cairo',
            ),
          ).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tFieldEntities));
        },
      );
    });
  });
}
