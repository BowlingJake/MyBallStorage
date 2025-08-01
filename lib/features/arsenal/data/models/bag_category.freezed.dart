// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bag_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BagCategory _$BagCategoryFromJson(Map<String, dynamic> json) {
  return _BagCategory.fromJson(json);
}

/// @nodoc
mixin _$BagCategory {
  String get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @IconDataConverter()
  IconData get icon => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get themeColor => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this BagCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BagCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BagCategoryCopyWith<BagCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BagCategoryCopyWith<$Res> {
  factory $BagCategoryCopyWith(
          BagCategory value, $Res Function(BagCategory) then) =
      _$BagCategoryCopyWithImpl<$Res, BagCategory>;
  @useResult
  $Res call(
      {String categoryId,
      String name,
      String userId,
      @IconDataConverter() IconData icon,
      @ColorConverter() Color themeColor,
      int displayOrder,
      bool isDefault,
      DateTime createdAt,
      String? description});
}

/// @nodoc
class _$BagCategoryCopyWithImpl<$Res, $Val extends BagCategory>
    implements $BagCategoryCopyWith<$Res> {
  _$BagCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BagCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? name = null,
    Object? userId = null,
    Object? icon = null,
    Object? themeColor = null,
    Object? displayOrder = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BagCategoryImplCopyWith<$Res>
    implements $BagCategoryCopyWith<$Res> {
  factory _$$BagCategoryImplCopyWith(
          _$BagCategoryImpl value, $Res Function(_$BagCategoryImpl) then) =
      __$$BagCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String name,
      String userId,
      @IconDataConverter() IconData icon,
      @ColorConverter() Color themeColor,
      int displayOrder,
      bool isDefault,
      DateTime createdAt,
      String? description});
}

/// @nodoc
class __$$BagCategoryImplCopyWithImpl<$Res>
    extends _$BagCategoryCopyWithImpl<$Res, _$BagCategoryImpl>
    implements _$$BagCategoryImplCopyWith<$Res> {
  __$$BagCategoryImplCopyWithImpl(
      _$BagCategoryImpl _value, $Res Function(_$BagCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BagCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? name = null,
    Object? userId = null,
    Object? icon = null,
    Object? themeColor = null,
    Object? displayOrder = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_$BagCategoryImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BagCategoryImpl implements _BagCategory {
  const _$BagCategoryImpl(
      {required this.categoryId,
      required this.name,
      required this.userId,
      @IconDataConverter() this.icon = Iconsax.bag,
      @ColorConverter() this.themeColor = const Color(0xFF2E7D32),
      this.displayOrder = 0,
      this.isDefault = false,
      required this.createdAt,
      this.description});

  factory _$BagCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BagCategoryImplFromJson(json);

  @override
  final String categoryId;
  @override
  final String name;
  @override
  final String userId;
  @override
  @JsonKey()
  @IconDataConverter()
  final IconData icon;
  @override
  @JsonKey()
  @ColorConverter()
  final Color themeColor;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime createdAt;
  @override
  final String? description;

  @override
  String toString() {
    return 'BagCategory(categoryId: $categoryId, name: $name, userId: $userId, icon: $icon, themeColor: $themeColor, displayOrder: $displayOrder, isDefault: $isDefault, createdAt: $createdAt, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BagCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, name, userId, icon,
      themeColor, displayOrder, isDefault, createdAt, description);

  /// Create a copy of BagCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BagCategoryImplCopyWith<_$BagCategoryImpl> get copyWith =>
      __$$BagCategoryImplCopyWithImpl<_$BagCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BagCategoryImplToJson(
      this,
    );
  }
}

abstract class _BagCategory implements BagCategory {
  const factory _BagCategory(
      {required final String categoryId,
      required final String name,
      required final String userId,
      @IconDataConverter() final IconData icon,
      @ColorConverter() final Color themeColor,
      final int displayOrder,
      final bool isDefault,
      required final DateTime createdAt,
      final String? description}) = _$BagCategoryImpl;

  factory _BagCategory.fromJson(Map<String, dynamic> json) =
      _$BagCategoryImpl.fromJson;

  @override
  String get categoryId;
  @override
  String get name;
  @override
  String get userId;
  @override
  @IconDataConverter()
  IconData get icon;
  @override
  @ColorConverter()
  Color get themeColor;
  @override
  int get displayOrder;
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;
  @override
  String? get description;

  /// Create a copy of BagCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BagCategoryImplCopyWith<_$BagCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
