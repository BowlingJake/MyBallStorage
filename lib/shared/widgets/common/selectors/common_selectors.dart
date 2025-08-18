import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/interfaces/selectable_item.dart';
import 'package:bowlingarsenal_app/shared/models/selector_config.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/selectors/universal_selector.dart';

/// 語言選擇器
class LanguageSelector extends StatelessWidget {
  final String? selectedLanguage;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const LanguageSelector({
    super.key,
    this.selectedLanguage,
    this.onChanged,
    this.enabled = true,
  });

  static final List<LanguageItem> _languages = [
    LanguageItem('en', 'English', '🇺🇸', 'International'),
    LanguageItem('zh-TW', '繁體中文', '🇹🇼', 'Chinese'),
    LanguageItem('zh-CN', '简体中文', '🇨🇳', 'Chinese'),
    LanguageItem('ja', '日本語', '🇯🇵', 'Asian'),
    LanguageItem('ko', '한국어', '🇰🇷', 'Asian'),
    LanguageItem('es', 'Español', '🇪🇸', 'European'),
    LanguageItem('fr', 'Français', '🇫🇷', 'European'),
    LanguageItem('de', 'Deutsch', '🇩🇪', 'European'),
    LanguageItem('pt', 'Português', '🇵🇹', 'European'),
    LanguageItem('ru', 'Русский', '🇷🇺', 'European'),
  ];

  @override
  Widget build(BuildContext context) {
    return UniversalSelector<String>(
      selectedValue: selectedLanguage,
      items: _languages,
      onChanged: onChanged,
      config: SelectorConfig.language,
      enabled: enabled,
    );
  }
}

class LanguageItem implements SelectableItem<String> {
  final String code;
  final String name;
  final String flag;
  final String region;

  const LanguageItem(this.code, this.name, this.flag, this.region);

  @override
  String get value => code;

  @override
  String get displayText => name;

  @override
  String get searchText => '$name $code';

  @override
  Widget? get leadingWidget => Text(flag, style: const TextStyle(fontSize: 20));

  @override
  String? get subtitle => code;

  @override
  Widget? get trailingWidget => null;

  @override
  TextStyle? get customTextStyle => null;

  @override
  bool get isEnabled => true;

  @override
  String? get groupKey => region;

  @override
  String? get groupDisplayName => region;

  @override
  int get sortWeight => code == 'en' ? 0 : (code.startsWith('zh') ? 1 : 10);
}

/// 貨幣選擇器
class CurrencySelector extends StatelessWidget {
  final String? selectedCurrency;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const CurrencySelector({
    super.key,
    this.selectedCurrency,
    this.onChanged,
    this.enabled = true,
  });

  static final List<CurrencyItem> _currencies = [
    CurrencyItem('USD', 'US Dollar', '\$', 'Americas'),
    CurrencyItem('EUR', 'Euro', '€', 'Europe'),
    CurrencyItem('TWD', 'Taiwan Dollar', 'NT\$', 'Asia'),
    CurrencyItem('JPY', 'Japanese Yen', '¥', 'Asia'),
    CurrencyItem('KRW', 'Korean Won', '₩', 'Asia'),
    CurrencyItem('CNY', 'Chinese Yuan', '¥', 'Asia'),
    CurrencyItem('GBP', 'British Pound', '£', 'Europe'),
    CurrencyItem('AUD', 'Australian Dollar', 'A\$', 'Oceania'),
    CurrencyItem('CAD', 'Canadian Dollar', 'C\$', 'Americas'),
    CurrencyItem('SGD', 'Singapore Dollar', 'S\$', 'Asia'),
  ];

  @override
  Widget build(BuildContext context) {
    final config = SelectorConfig.simple.copyWith(
      title: 'Select Currency',
      searchHint: 'Search currencies...',
      buttonHint: 'Select Currency',
      showSearch: true,
      showGroups: true,
    );

    return UniversalSelector<String>(
      selectedValue: selectedCurrency,
      items: _currencies,
      onChanged: onChanged,
      config: config,
      enabled: enabled,
    );
  }
}

class CurrencyItem implements SelectableItem<String> {
  final String code;
  final String name;
  final String symbol;
  final String region;

  const CurrencyItem(this.code, this.name, this.symbol, this.region);

  @override
  String get value => code;

  @override
  String get displayText => name;

  @override
  String get searchText => '$name $code $symbol';

  @override
  Widget? get leadingWidget => Container(
    width: 32,
    height: 24,
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Center(
      child: Text(
        symbol,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  @override
  String? get subtitle => code;

  @override
  Widget? get trailingWidget => null;

  @override
  TextStyle? get customTextStyle => null;

  @override
  bool get isEnabled => true;

  @override
  String? get groupKey => region;

  @override
  String? get groupDisplayName => region;

  @override
  int get sortWeight => code == 'USD' ? 0 : (code == 'TWD' ? 1 : 10);
}

/// 時區選擇器
class TimezoneSelector extends StatelessWidget {
  final String? selectedTimezone;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const TimezoneSelector({
    super.key,
    this.selectedTimezone,
    this.onChanged,
    this.enabled = true,
  });

  static final List<TimezoneItem> _timezones = [
    TimezoneItem('UTC+8', 'Taipei', 'Asia/Taipei', 'Asia'),
    TimezoneItem('UTC+9', 'Tokyo', 'Asia/Tokyo', 'Asia'),
    TimezoneItem('UTC+9', 'Seoul', 'Asia/Seoul', 'Asia'),
    TimezoneItem('UTC-8', 'Los Angeles', 'America/Los_Angeles', 'Americas'),
    TimezoneItem('UTC-5', 'New York', 'America/New_York', 'Americas'),
    TimezoneItem('UTC+0', 'London', 'Europe/London', 'Europe'),
    TimezoneItem('UTC+1', 'Paris', 'Europe/Paris', 'Europe'),
    TimezoneItem('UTC+1', 'Berlin', 'Europe/Berlin', 'Europe'),
    TimezoneItem('UTC+10', 'Sydney', 'Australia/Sydney', 'Oceania'),
  ];

  @override
  Widget build(BuildContext context) {
    final config = SelectorConfig.bulk.copyWith(
      title: 'Select Timezone',
      searchHint: 'Search timezones...',
      buttonHint: 'Select Timezone',
    );

    return UniversalSelector<String>(
      selectedValue: selectedTimezone,
      items: _timezones,
      onChanged: onChanged,
      config: config,
      enabled: enabled,
    );
  }
}

class TimezoneItem implements SelectableItem<String> {
  final String offset;
  final String city;
  final String timezone;
  final String region;

  const TimezoneItem(this.offset, this.city, this.timezone, this.region);

  @override
  String get value => timezone;

  @override
  String get displayText => city;

  @override
  String get searchText => '$city $timezone $offset';

  @override
  Widget? get leadingWidget => Container(
    width: 48,
    height: 24,
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        offset,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  @override
  String? get subtitle => timezone;

  @override
  Widget? get trailingWidget => null;

  @override
  TextStyle? get customTextStyle => null;

  @override
  bool get isEnabled => true;

  @override
  String? get groupKey => region;

  @override
  String? get groupDisplayName => region;

  @override
  int get sortWeight => timezone.contains('Taipei') ? 0 : 10;
}