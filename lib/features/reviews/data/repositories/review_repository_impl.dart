import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/data/datasources/review_remote_datasource.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';

/// Implementation of ReviewRepository.
///
/// Handles review data operations using the remote data source.
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReviewEntity>> createReview({
    required String fieldId,
    required String userId,
    String? bookingId,
    required int rating,
    String? comment,
  }) async {
    try {
      final review = await remoteDataSource.createReview(
        fieldId: fieldId,
        userId: userId,
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create review: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getFieldReviews({
    required String fieldId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final reviews = await remoteDataSource.getFieldReviews(
        fieldId: fieldId,
        limit: limit,
        offset: offset,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch reviews: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId) async {
    try {
      final review = await remoteDataSource.getReviewById(reviewId);
      return Right(review);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch review: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity?>> getUserFieldReview({
    required String userId,
    required String fieldId,
  }) async {
    try {
      final review = await remoteDataSource.getUserFieldReview(
        userId: userId,
        fieldId: fieldId,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch user field review: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final review = await remoteDataSource.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update review: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await remoteDataSource.deleteReview(reviewId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete review: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> canUserReviewField({
    required String userId,
    required String fieldId,
    required String bookingId,
  }) async {
    try {
      final canReview = await remoteDataSource.canUserReviewField(
        userId: userId,
        fieldId: fieldId,
        bookingId: bookingId,
      );
      return Right(canReview);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to check review eligibility: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getUserReviews({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final reviews = await remoteDataSource.getUserReviews(
        userId: userId,
        limit: limit,
        offset: offset,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch user reviews: ${e.toString()}'),
      );
    }
  }
}
