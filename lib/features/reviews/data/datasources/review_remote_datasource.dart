import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/reviews/data/models/review_model.dart';
import 'package:spo_kick/features/reviews/data/mappers/review_response_mapper.dart';

/// Remote data source for review operations.
///
/// Handles all review-related API calls to Supabase.
abstract class ReviewRemoteDataSource {
  /// Create a new review
  Future<ReviewModel> createReview({
    required String fieldId,
    required String userId,
    String? bookingId,
    required int rating,
    String? comment,
  });

  /// Get reviews for a specific field
  Future<List<ReviewModel>> getFieldReviews({
    required String fieldId,
    int limit = 20,
    int offset = 0,
  });

  /// Get a specific review by ID
  Future<ReviewModel> getReviewById(String reviewId);

  /// Get user's review for a specific field
  Future<ReviewModel?> getUserFieldReview({
    required String userId,
    required String fieldId,
  });

  /// Update an existing review
  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  });

  /// Delete a review
  Future<void> deleteReview(String reviewId);

  /// Check if user can review a field
  Future<bool> canUserReviewField({
    required String userId,
    required String fieldId,
    required String bookingId,
  });

  /// Get all reviews by a specific user
  Future<List<ReviewModel>> getUserReviews({
    required String userId,
    int limit = 20,
    int offset = 0,
  });
}

/// Implementation of ReviewRemoteDataSource using Supabase
class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReviewRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ReviewModel> createReview({
    required String fieldId,
    required String userId,
    String? bookingId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await supabaseClient
          .from('reviews')
          .insert({
            'field_id': fieldId,
            'user_id': userId,
            if (bookingId != null) 'booking_id': bookingId,
            'rating': rating,
            if (comment != null) 'comment': comment,
          })
          .select('''
            *,
            user_name:profiles!user_id(full_name),
            user_avatar:profiles!user_id(avatar_url)
          ''')
          .single();

      return ReviewResponseMapper.fromSupabaseResponse(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to create review: ${e.toString()}');
    }
  }

  @override
  Future<List<ReviewModel>> getFieldReviews({
    required String fieldId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await supabaseClient
          .from('reviews')
          .select('''
            *,
            user_name:profiles!user_id(full_name),
            user_avatar:profiles!user_id(avatar_url)
          ''')
          .eq('field_id', fieldId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return ReviewResponseMapper.fromSupabaseResponseList(response as List);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch reviews: ${e.toString()}');
    }
  }

  @override
  Future<ReviewModel> getReviewById(String reviewId) async {
    try {
      final response = await supabaseClient
          .from('reviews')
          .select('''
            *,
            user_name:profiles!user_id(full_name),
            user_avatar:profiles!user_id(avatar_url)
          ''')
          .eq('id', reviewId)
          .single();

      return ReviewResponseMapper.fromSupabaseResponse(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const NotFoundException('Review not found');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch review: ${e.toString()}');
    }
  }

  @override
  Future<ReviewModel?> getUserFieldReview({
    required String userId,
    required String fieldId,
  }) async {
    try {
      final response = await supabaseClient
          .from('reviews')
          .select('''
            *,
            user_name:profiles!user_id(full_name),
            user_avatar:profiles!user_id(avatar_url)
          ''')
          .eq('user_id', userId)
          .eq('field_id', fieldId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return ReviewResponseMapper.fromSupabaseResponse(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(
        'Failed to fetch user field review: ${e.toString()}',
      );
    }
  }

  @override
  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (rating != null) updateData['rating'] = rating;
      if (comment != null) updateData['comment'] = comment;

      if (updateData.isEmpty) {
        throw const ServerException('No fields to update');
      }

      final response = await supabaseClient
          .from('reviews')
          .update(updateData)
          .eq('id', reviewId)
          .select('''
            *,
            user_name:profiles!user_id(full_name),
            user_avatar:profiles!user_id(avatar_url)
          ''')
          .single();

      return ReviewResponseMapper.fromSupabaseResponse(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to update review: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await supabaseClient.from('reviews').delete().eq('id', reviewId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to delete review: ${e.toString()}');
    }
  }

  @override
  Future<bool> canUserReviewField({
    required String userId,
    required String fieldId,
    required String bookingId,
  }) async {
    try {
      final result = await supabaseClient.rpc(
        'can_user_review_field',
        params: {
          'p_user_id': userId,
          'p_field_id': fieldId,
          'p_booking_id': bookingId,
        },
      );

      return result as bool;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(
        'Failed to check review eligibility: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ReviewModel>> getUserReviews({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await supabaseClient
          .from('reviews')
          .select('''
            *,
            user_name:profiles!user_id(full_name),
            user_avatar:profiles!user_id(avatar_url)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return ReviewResponseMapper.fromSupabaseResponseList(response as List);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to fetch user reviews: ${e.toString()}');
    }
  }
}
