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
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_code_point')
  int get iconCodePoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_font_family')
  String get iconFontFamily => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_font_package')
  String? get iconFontPackage => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_color')
  @ColorConverter()
  Color get themeColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
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
      {@JsonKey(name: 'category_id') String categoryId,
      String name,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'icon_code_point') int iconCodePoint,
      @JsonKey(name: 'icon_font_family') String iconFontFamily,
      @JsonKey(name: 'icon_font_package') String? iconFontPackage,
      @JsonKey(name: 'theme_color') @ColorConverter() Color themeColor,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') DateTime createdAt,
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
    Object? iconCodePoint = null,
    Object? iconFontFamily = null,
    Object? iconFontPackage = freezed,
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
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      iconFontFamily: null == iconFontFamily
          ? _value.iconFontFamily
          : iconFontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      iconFontPackage: freezed == iconFontPackage
          ? _value.iconFontPackage
          : iconFontPackage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {@JsonKey(name: 'category_id') String categoryId,
      String name,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'icon_code_point') int iconCodePoint,
      @JsonKey(name: 'icon_font_family') String iconFontFamily,
      @JsonKey(name: 'icon_font_package') String? iconFontPackage,
      @JsonKey(name: 'theme_color') @ColorConverter() Color themeColor,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') DateTime createdAt,
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
    Object? iconCodePoint = null,
    Object? iconFontFamily = null,
    Object? iconFontPackage = freezed,
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
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      iconFontFamily: null == iconFontFamily
          ? _value.iconFontFamily
          : iconFontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      iconFontPackage: freezed == iconFontPackage
          ? _value.iconFontPackage
          : iconFontPackage // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {@JsonKey(name: 'category_id') required this.categoryId,
      required this.name,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'icon_code_point') this.iconCodePoint = 57669,
      @JsonKey(name: 'icon_font_family') this.iconFontFamily = 'Iconsax',
      @JsonKey(name: 'icon_font_package') this.iconFontPackage = 'iconsax',
      @JsonKey(name: 'theme_color')
      @ColorConverter()
      this.themeColor = const Color(0xFF2E7D32),
      @JsonKey(name: 'display_order') this.displayOrder = 0,
      @JsonKey(name: 'is_default') this.isDefault = false,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.description});

  factory _$BagCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BagCategoryImplFromJson(json);

  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final String name;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'icon_code_point')
  final int iconCodePoint;
  @override
  @JsonKey(name: 'icon_font_family')
  final String iconFontFamily;
  @override
  @JsonKey(name: 'icon_font_package')
  final String? iconFontPackage;
  @override
  @JsonKey(name: 'theme_color')
  @ColorConverter()
  final Color themeColor;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final String? description;

  @override
  String toString() {
    return 'BagCategory(categoryId: $categoryId, name: $name, userId: $userId, iconCodePoint: $iconCodePoint, iconFontFamily: $iconFontFamily, iconFontPackage: $iconFontPackage, themeColor: $themeColor, displayOrder: $displayOrder, isDefault: $isDefault, createdAt: $createdAt, description: $description)';
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
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint) &&
            (identical(other.iconFontFamily, iconFontFamily) ||
                other.iconFontFamily == iconFontFamily) &&
            (identical(other.iconFontPackage, iconFontPackage) ||
                other.iconFontPackage == iconFontPackage) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      categoryId,
      name,
      userId,
      iconCodePoint,
      iconFontFamily,
      iconFontPackage,
      themeColor,
      displayOrder,
      isDefault,
      createdAt,
      description);

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
      {@JsonKey(name: 'category_id') required final String categoryId,
      required final String name,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'icon_code_point') final int iconCodePoint,
      @JsonKey(name: 'icon_font_family') final String iconFontFamily,
      @JsonKey(name: 'icon_font_package') final String? iconFontPackage,
      @JsonKey(name: 'theme_color') @ColorConverter() final Color themeColor,
      @JsonKey(name: 'display_order') final int displayOrder,
      @JsonKey(name: 'is_default') final bool isDefault,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final String? description}) = _$BagCategoryImpl;

  factory _BagCategory.fromJson(Map<String, dynamic> json) =
      _$BagCategoryImpl.fromJson;

  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  String get name;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'icon_code_point')
  int get iconCodePoint;
  @override
  @JsonKey(name: 'icon_font_family')
  String get iconFontFamily;
  @override
  @JsonKey(name: 'icon_font_package')
  String? get iconFontPackage;
  @override
  @JsonKey(name: 'theme_color')
  @ColorConverter()
  Color get themeColor;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'created_at')
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
