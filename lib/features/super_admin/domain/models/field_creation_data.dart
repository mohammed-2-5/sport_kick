import 'package:equatable/equatable.dart';

/// Data transfer object for field creation.
///
/// Contains all data needed to create a field.
/// Used to pass data from UI to cubit without logic in UI.
class FieldCreationData extends Equatable {
  final String? adminId;
  final String name;
  final String? description;
  final String address;
  final String? city;
  final String priceText;
  final String? sportCategory;
  final String size;
  final String surface;
  final bool isIndoor;
  final List<String> facilities;
  final String? paymentPhone;
  final String paymentMethod;

  const FieldCreationData({
    required this.adminId,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.priceText,
    required this.sportCategory,
    required this.size,
    required this.surface,
    required this.isIndoor,
    required this.facilities,
    this.paymentPhone,
    this.paymentMethod = 'vodafone_cash',
  });

  @override
  List<Object?> get props => [
    adminId,
    name,
    description,
    address,
    city,
    priceText,
    sportCategory,
    size,
    surface,
    isIndoor,
    facilities,
    paymentPhone,
    paymentMethod,
  ];
}
