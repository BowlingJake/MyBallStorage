import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/models/country_model.dart';
import 'package:bowlingarsenal_app/shared/models/selector_config.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/selectors/universal_selector.dart';

/// 完全按字母順序排列的國家選擇器
/// 不給任何國家特殊優先權，純粹按字母順序
class AlphabeticalCountrySelector extends StatelessWidget {
  final Country? selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final bool enabled;
  final bool showGroups;

  const AlphabeticalCountrySelector({
    super.key,
    this.selectedCountry,
    this.onChanged,
    this.enabled = true,
    this.showGroups = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = SelectorConfig.country.copyWith(
      title: 'Select Country',
      showGroups: showGroups,
      customSortComparator: (a, b) {
        // 完全按國家名稱字母順序排序，不考慮權重
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