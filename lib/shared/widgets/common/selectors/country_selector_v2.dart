import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/models/country_model.dart';
import 'package:bowlingarsenal_app/shared/models/selector_config.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/selectors/universal_selector.dart';

/// 國家選擇器 V2 - 基於通用選擇器架構
/// 支援搜尋、分組、自訂配置等高級功能
class CountrySelectorV2 extends StatelessWidget {
  final Country? selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final bool enabled;
  final SelectorConfig? customConfig;
  final bool showGroups;

  const CountrySelectorV2({
    super.key,
    this.selectedCountry,
    this.onChanged,
    this.enabled = true,
    this.customConfig,
    this.showGroups = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = (customConfig ?? SelectorConfig.country).copyWith(
      showGroups: showGroups,
      // 完全按字母順序排序，無任何優先權
      customSortComparator: (a, b) {
        final countryA = a as Country;
        final countryB = b as Country;
        return countryA.name.compareTo(countryB.name);
      },
    );

    return UniversalSelector<Country>(
      selectedValue: selectedCountry,
      items: Countries.all.cast<Country>(),
      onChanged: onChanged,
      config: config,
      enabled: enabled,
    );
  }
}

/// 簡化的國家代碼選擇器
class CountryCodeSelectorV2 extends StatelessWidget {
  final Country? selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final bool enabled;

  const CountryCodeSelectorV2({
    super.key,
    this.selectedCountry,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = SelectorConfig.country.copyWith(
      buttonHint: 'Select',
      showGroups: false,
      maxHeightRatio: 0.7,
    );

    return SizedBox(
      width: 120, // 固定寬度適合代碼顯示
      child: UniversalSelector<Country>(
        selectedValue: selectedCountry,
        items: Countries.all.cast<Country>(),
        onChanged: onChanged,
        config: config,
        enabled: enabled,
      ),
    );
  }
}

/// 分組國家選擇器 - 按地區分組顯示
class GroupedCountrySelectorV2 extends StatelessWidget {
  final Country? selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final bool enabled;

  const GroupedCountrySelectorV2({
    super.key,
    this.selectedCountry,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = SelectorConfig.country.copyWith(
      title: 'Select Country by Region',
      showGroups: true,
      maxHeightRatio: 0.9,
    );

    return UniversalSelector<Country>(
      selectedValue: selectedCountry,
      items: Countries.all.cast<Country>(),
      onChanged: onChanged,
      config: config,
      enabled: enabled,
    );
  }
}