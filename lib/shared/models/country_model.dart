import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/interfaces/selectable_item.dart';

/// 國家數據模型
class Country implements SelectableItem<Country> {
  final String code;        // 國家代碼 (ISO 3166-1 alpha-2)
  final String name;        // 國家名稱
  final String dialCode;    // 國際電話區號
  final String flag;        // 國旗 emoji

  const Country({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$flag $name ($code)';

  // 實現 SelectableItem 介面
  @override
  Country get value => this;

  @override
  String get displayText => name;

  @override
  String get searchText => name; // 只搜尋國家名稱

  @override
  Widget? get leadingWidget => Text(
    flag,
    style: const TextStyle(fontSize: 16),
  );

  @override
  String? get subtitle => null; // 不顯示副標題

  @override
  Widget? get trailingWidget => null;

  @override
  TextStyle? get customTextStyle => null;

  @override
  bool get isEnabled => true;

  @override
  String? get groupKey {
    // 按字母順序分組 (A-D, E-H, I-L, M-P, Q-T, U-Z)
    final firstChar = name[0].toUpperCase();
    if (firstChar.compareTo('A') >= 0 && firstChar.compareTo('D') <= 0) {
      return 'A-D';
    } else if (firstChar.compareTo('E') >= 0 && firstChar.compareTo('H') <= 0) {
      return 'E-H';
    } else if (firstChar.compareTo('I') >= 0 && firstChar.compareTo('L') <= 0) {
      return 'I-L';
    } else if (firstChar.compareTo('M') >= 0 && firstChar.compareTo('P') <= 0) {
      return 'M-P';
    } else if (firstChar.compareTo('Q') >= 0 && firstChar.compareTo('T') <= 0) {
      return 'Q-T';
    } else {
      return 'U-Z';
    }
  }

  @override
  String? get groupDisplayName => groupKey;

  @override
  int get sortWeight {
    // 常用國家權重較低（排前面），其他國家按字母順序
    switch (code) {
      case 'TW':
        return 0; // 台灣最優先
      case 'US':
        return 1;
      case 'CN':
        return 2;
      case 'JP':
        return 3;
      case 'KR':
        return 4;
      case 'GB':
        return 5;
      default:
        return 100 + name.codeUnitAt(0); // 其他國家按首字母ASCII排序
    }
  }
}

/// 世界所有國家數據（195個聯合國會員國 + 特殊地區）
class Countries {
  static const List<Country> all = [
    // A
    Country(code: 'AF', name: 'Afghanistan', dialCode: '+93', flag: '🇦🇫'),
    Country(code: 'AL', name: 'Albania', dialCode: '+355', flag: '🇦🇱'),
    Country(code: 'DZ', name: 'Algeria', dialCode: '+213', flag: '🇩🇿'),
    Country(code: 'AD', name: 'Andorra', dialCode: '+376', flag: '🇦🇩'),
    Country(code: 'AO', name: 'Angola', dialCode: '+244', flag: '🇦🇴'),
    Country(code: 'AG', name: 'Antigua and Barbuda', dialCode: '+1', flag: '🇦🇬'),
    Country(code: 'AR', name: 'Argentina', dialCode: '+54', flag: '🇦🇷'),
    Country(code: 'AM', name: 'Armenia', dialCode: '+374', flag: '🇦🇲'),
    Country(code: 'AU', name: 'Australia', dialCode: '+61', flag: '🇦🇺'),
    Country(code: 'AT', name: 'Austria', dialCode: '+43', flag: '🇦🇹'),
    Country(code: 'AZ', name: 'Azerbaijan', dialCode: '+994', flag: '🇦🇿'),
    
    // B
    Country(code: 'BS', name: 'Bahamas', dialCode: '+1', flag: '🇧🇸'),
    Country(code: 'BH', name: 'Bahrain', dialCode: '+973', flag: '🇧🇭'),
    Country(code: 'BD', name: 'Bangladesh', dialCode: '+880', flag: '🇧🇩'),
    Country(code: 'BB', name: 'Barbados', dialCode: '+1', flag: '🇧🇧'),
    Country(code: 'BY', name: 'Belarus', dialCode: '+375', flag: '🇧🇾'),
    Country(code: 'BE', name: 'Belgium', dialCode: '+32', flag: '🇧🇪'),
    Country(code: 'BZ', name: 'Belize', dialCode: '+501', flag: '🇧🇿'),
    Country(code: 'BJ', name: 'Benin', dialCode: '+229', flag: '🇧🇯'),
    Country(code: 'BT', name: 'Bhutan', dialCode: '+975', flag: '🇧🇹'),
    Country(code: 'BO', name: 'Bolivia', dialCode: '+591', flag: '🇧🇴'),
    Country(code: 'BA', name: 'Bosnia and Herzegovina', dialCode: '+387', flag: '🇧🇦'),
    Country(code: 'BW', name: 'Botswana', dialCode: '+267', flag: '🇧🇼'),
    Country(code: 'BR', name: 'Brazil', dialCode: '+55', flag: '🇧🇷'),
    Country(code: 'BN', name: 'Brunei', dialCode: '+673', flag: '🇧🇳'),
    Country(code: 'BG', name: 'Bulgaria', dialCode: '+359', flag: '🇧🇬'),
    Country(code: 'BF', name: 'Burkina Faso', dialCode: '+226', flag: '🇧🇫'),
    Country(code: 'BI', name: 'Burundi', dialCode: '+257', flag: '🇧🇮'),
    
    // C
    Country(code: 'CV', name: 'Cabo Verde', dialCode: '+238', flag: '🇨🇻'),
    Country(code: 'KH', name: 'Cambodia', dialCode: '+855', flag: '🇰🇭'),
    Country(code: 'CM', name: 'Cameroon', dialCode: '+237', flag: '🇨🇲'),
    Country(code: 'CA', name: 'Canada', dialCode: '+1', flag: '🇨🇦'),
    Country(code: 'CF', name: 'Central African Republic', dialCode: '+236', flag: '🇨🇫'),
    Country(code: 'TD', name: 'Chad', dialCode: '+235', flag: '🇹🇩'),
    Country(code: 'CL', name: 'Chile', dialCode: '+56', flag: '🇨🇱'),
    Country(code: 'CN', name: 'China', dialCode: '+86', flag: '🇨🇳'),
    Country(code: 'CO', name: 'Colombia', dialCode: '+57', flag: '🇨🇴'),
    Country(code: 'KM', name: 'Comoros', dialCode: '+269', flag: '🇰🇲'),
    Country(code: 'CG', name: 'Congo', dialCode: '+242', flag: '🇨🇬'),
    Country(code: 'CD', name: 'Congo (Democratic Republic)', dialCode: '+243', flag: '🇨🇩'),
    Country(code: 'CR', name: 'Costa Rica', dialCode: '+506', flag: '🇨🇷'),
    Country(code: 'HR', name: 'Croatia', dialCode: '+385', flag: '🇭🇷'),
    Country(code: 'CU', name: 'Cuba', dialCode: '+53', flag: '🇨🇺'),
    Country(code: 'CY', name: 'Cyprus', dialCode: '+357', flag: '🇨🇾'),
    Country(code: 'CZ', name: 'Czech Republic', dialCode: '+420', flag: '🇨🇿'),
    
    // D
    Country(code: 'DK', name: 'Denmark', dialCode: '+45', flag: '🇩🇰'),
    Country(code: 'DJ', name: 'Djibouti', dialCode: '+253', flag: '🇩🇯'),
    Country(code: 'DM', name: 'Dominica', dialCode: '+1', flag: '🇩🇲'),
    Country(code: 'DO', name: 'Dominican Republic', dialCode: '+1', flag: '🇩🇴'),
    
    // E
    Country(code: 'EC', name: 'Ecuador', dialCode: '+593', flag: '🇪🇨'),
    Country(code: 'EG', name: 'Egypt', dialCode: '+20', flag: '🇪🇬'),
    Country(code: 'SV', name: 'El Salvador', dialCode: '+503', flag: '🇸🇻'),
    Country(code: 'GQ', name: 'Equatorial Guinea', dialCode: '+240', flag: '🇬🇶'),
    Country(code: 'ER', name: 'Eritrea', dialCode: '+291', flag: '🇪🇷'),
    Country(code: 'EE', name: 'Estonia', dialCode: '+372', flag: '🇪🇪'),
    Country(code: 'SZ', name: 'Eswatini', dialCode: '+268', flag: '🇸🇿'),
    Country(code: 'ET', name: 'Ethiopia', dialCode: '+251', flag: '🇪🇹'),
    
    // F
    Country(code: 'FJ', name: 'Fiji', dialCode: '+679', flag: '🇫🇯'),
    Country(code: 'FI', name: 'Finland', dialCode: '+358', flag: '🇫🇮'),
    Country(code: 'FR', name: 'France', dialCode: '+33', flag: '🇫🇷'),
    
    // G
    Country(code: 'GA', name: 'Gabon', dialCode: '+241', flag: '🇬🇦'),
    Country(code: 'GM', name: 'Gambia', dialCode: '+220', flag: '🇬🇲'),
    Country(code: 'GE', name: 'Georgia', dialCode: '+995', flag: '🇬🇪'),
    Country(code: 'DE', name: 'Germany', dialCode: '+49', flag: '🇩🇪'),
    Country(code: 'GH', name: 'Ghana', dialCode: '+233', flag: '🇬🇭'),
    Country(code: 'GR', name: 'Greece', dialCode: '+30', flag: '🇬🇷'),
    Country(code: 'GD', name: 'Grenada', dialCode: '+1', flag: '🇬🇩'),
    Country(code: 'GT', name: 'Guatemala', dialCode: '+502', flag: '🇬🇹'),
    Country(code: 'GN', name: 'Guinea', dialCode: '+224', flag: '🇬🇳'),
    Country(code: 'GW', name: 'Guinea-Bissau', dialCode: '+245', flag: '🇬🇼'),
    Country(code: 'GY', name: 'Guyana', dialCode: '+592', flag: '🇬🇾'),
    
    // H
    Country(code: 'HT', name: 'Haiti', dialCode: '+509', flag: '🇭🇹'),
    Country(code: 'HN', name: 'Honduras', dialCode: '+504', flag: '🇭🇳'),
    Country(code: 'HU', name: 'Hungary', dialCode: '+36', flag: '🇭🇺'),
    
    // I
    Country(code: 'IS', name: 'Iceland', dialCode: '+354', flag: '🇮🇸'),
    Country(code: 'IN', name: 'India', dialCode: '+91', flag: '🇮🇳'),
    Country(code: 'ID', name: 'Indonesia', dialCode: '+62', flag: '🇮🇩'),
    Country(code: 'IR', name: 'Iran', dialCode: '+98', flag: '🇮🇷'),
    Country(code: 'IQ', name: 'Iraq', dialCode: '+964', flag: '🇮🇶'),
    Country(code: 'IE', name: 'Ireland', dialCode: '+353', flag: '🇮🇪'),
    Country(code: 'IL', name: 'Israel', dialCode: '+972', flag: '🇮🇱'),
    Country(code: 'IT', name: 'Italy', dialCode: '+39', flag: '🇮🇹'),
    Country(code: 'CI', name: 'Ivory Coast', dialCode: '+225', flag: '🇨🇮'),
    
    // J
    Country(code: 'JM', name: 'Jamaica', dialCode: '+1', flag: '🇯🇲'),
    Country(code: 'JP', name: 'Japan', dialCode: '+81', flag: '🇯🇵'),
    Country(code: 'JO', name: 'Jordan', dialCode: '+962', flag: '🇯🇴'),
    
    // K
    Country(code: 'KZ', name: 'Kazakhstan', dialCode: '+7', flag: '🇰🇿'),
    Country(code: 'KE', name: 'Kenya', dialCode: '+254', flag: '🇰🇪'),
    Country(code: 'KI', name: 'Kiribati', dialCode: '+686', flag: '🇰🇮'),
    Country(code: 'KP', name: 'Korea (North)', dialCode: '+850', flag: '🇰🇵'),
    Country(code: 'KR', name: 'Korea (South)', dialCode: '+82', flag: '🇰🇷'),
    Country(code: 'KW', name: 'Kuwait', dialCode: '+965', flag: '🇰🇼'),
    Country(code: 'KG', name: 'Kyrgyzstan', dialCode: '+996', flag: '🇰🇬'),
    
    // L
    Country(code: 'LA', name: 'Laos', dialCode: '+856', flag: '🇱🇦'),
    Country(code: 'LV', name: 'Latvia', dialCode: '+371', flag: '🇱🇻'),
    Country(code: 'LB', name: 'Lebanon', dialCode: '+961', flag: '🇱🇧'),
    Country(code: 'LS', name: 'Lesotho', dialCode: '+266', flag: '🇱🇸'),
    Country(code: 'LR', name: 'Liberia', dialCode: '+231', flag: '🇱🇷'),
    Country(code: 'LY', name: 'Libya', dialCode: '+218', flag: '🇱🇾'),
    Country(code: 'LI', name: 'Liechtenstein', dialCode: '+423', flag: '🇱🇮'),
    Country(code: 'LT', name: 'Lithuania', dialCode: '+370', flag: '🇱🇹'),
    Country(code: 'LU', name: 'Luxembourg', dialCode: '+352', flag: '🇱🇺'),
    
    // M
    Country(code: 'MG', name: 'Madagascar', dialCode: '+261', flag: '🇲🇬'),
    Country(code: 'MW', name: 'Malawi', dialCode: '+265', flag: '🇲🇼'),
    Country(code: 'MY', name: 'Malaysia', dialCode: '+60', flag: '🇲🇾'),
    Country(code: 'MV', name: 'Maldives', dialCode: '+960', flag: '🇲🇻'),
    Country(code: 'ML', name: 'Mali', dialCode: '+223', flag: '🇲🇱'),
    Country(code: 'MT', name: 'Malta', dialCode: '+356', flag: '🇲🇹'),
    Country(code: 'MH', name: 'Marshall Islands', dialCode: '+692', flag: '🇲🇭'),
    Country(code: 'MR', name: 'Mauritania', dialCode: '+222', flag: '🇲🇷'),
    Country(code: 'MU', name: 'Mauritius', dialCode: '+230', flag: '🇲🇺'),
    Country(code: 'MX', name: 'Mexico', dialCode: '+52', flag: '🇲🇽'),
    Country(code: 'FM', name: 'Micronesia', dialCode: '+691', flag: '🇫🇲'),
    Country(code: 'MD', name: 'Moldova', dialCode: '+373', flag: '🇲🇩'),
    Country(code: 'MC', name: 'Monaco', dialCode: '+377', flag: '🇲🇨'),
    Country(code: 'MN', name: 'Mongolia', dialCode: '+976', flag: '🇲🇳'),
    Country(code: 'ME', name: 'Montenegro', dialCode: '+382', flag: '🇲🇪'),
    Country(code: 'MA', name: 'Morocco', dialCode: '+212', flag: '🇲🇦'),
    Country(code: 'MZ', name: 'Mozambique', dialCode: '+258', flag: '🇲🇿'),
    Country(code: 'MM', name: 'Myanmar', dialCode: '+95', flag: '🇲🇲'),
    
    // N
    Country(code: 'NA', name: 'Namibia', dialCode: '+264', flag: '🇳🇦'),
    Country(code: 'NR', name: 'Nauru', dialCode: '+674', flag: '🇳🇷'),
    Country(code: 'NP', name: 'Nepal', dialCode: '+977', flag: '🇳🇵'),
    Country(code: 'NL', name: 'Netherlands', dialCode: '+31', flag: '🇳🇱'),
    Country(code: 'NZ', name: 'New Zealand', dialCode: '+64', flag: '🇳🇿'),
    Country(code: 'NI', name: 'Nicaragua', dialCode: '+505', flag: '🇳🇮'),
    Country(code: 'NE', name: 'Niger', dialCode: '+227', flag: '🇳🇪'),
    Country(code: 'NG', name: 'Nigeria', dialCode: '+234', flag: '🇳🇬'),
    Country(code: 'MK', name: 'North Macedonia', dialCode: '+389', flag: '🇲🇰'),
    Country(code: 'NO', name: 'Norway', dialCode: '+47', flag: '🇳🇴'),
    
    // O
    Country(code: 'OM', name: 'Oman', dialCode: '+968', flag: '🇴🇲'),
    
    // P
    Country(code: 'PK', name: 'Pakistan', dialCode: '+92', flag: '🇵🇰'),
    Country(code: 'PW', name: 'Palau', dialCode: '+680', flag: '🇵🇼'),
    Country(code: 'PA', name: 'Panama', dialCode: '+507', flag: '🇵🇦'),
    Country(code: 'PG', name: 'Papua New Guinea', dialCode: '+675', flag: '🇵🇬'),
    Country(code: 'PY', name: 'Paraguay', dialCode: '+595', flag: '🇵🇾'),
    Country(code: 'PE', name: 'Peru', dialCode: '+51', flag: '🇵🇪'),
    Country(code: 'PH', name: 'Philippines', dialCode: '+63', flag: '🇵🇭'),
    Country(code: 'PL', name: 'Poland', dialCode: '+48', flag: '🇵🇱'),
    Country(code: 'PT', name: 'Portugal', dialCode: '+351', flag: '🇵🇹'),
    
    // Q
    Country(code: 'QA', name: 'Qatar', dialCode: '+974', flag: '🇶🇦'),
    
    // R
    Country(code: 'RO', name: 'Romania', dialCode: '+40', flag: '🇷🇴'),
    Country(code: 'RU', name: 'Russia', dialCode: '+7', flag: '🇷🇺'),
    Country(code: 'RW', name: 'Rwanda', dialCode: '+250', flag: '🇷🇼'),
    
    // S
    Country(code: 'KN', name: 'Saint Kitts and Nevis', dialCode: '+1', flag: '🇰🇳'),
    Country(code: 'LC', name: 'Saint Lucia', dialCode: '+1', flag: '🇱🇨'),
    Country(code: 'VC', name: 'Saint Vincent and the Grenadines', dialCode: '+1', flag: '🇻🇨'),
    Country(code: 'WS', name: 'Samoa', dialCode: '+685', flag: '🇼🇸'),
    Country(code: 'SM', name: 'San Marino', dialCode: '+378', flag: '🇸🇲'),
    Country(code: 'ST', name: 'Sao Tome and Principe', dialCode: '+239', flag: '🇸🇹'),
    Country(code: 'SA', name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦'),
    Country(code: 'SN', name: 'Senegal', dialCode: '+221', flag: '🇸🇳'),
    Country(code: 'RS', name: 'Serbia', dialCode: '+381', flag: '🇷🇸'),
    Country(code: 'SC', name: 'Seychelles', dialCode: '+248', flag: '🇸🇨'),
    Country(code: 'SL', name: 'Sierra Leone', dialCode: '+232', flag: '🇸🇱'),
    Country(code: 'SG', name: 'Singapore', dialCode: '+65', flag: '🇸🇬'),
    Country(code: 'SK', name: 'Slovakia', dialCode: '+421', flag: '🇸🇰'),
    Country(code: 'SI', name: 'Slovenia', dialCode: '+386', flag: '🇸🇮'),
    Country(code: 'SB', name: 'Solomon Islands', dialCode: '+677', flag: '🇸🇧'),
    Country(code: 'SO', name: 'Somalia', dialCode: '+252', flag: '🇸🇴'),
    Country(code: 'ZA', name: 'South Africa', dialCode: '+27', flag: '🇿🇦'),
    Country(code: 'SS', name: 'South Sudan', dialCode: '+211', flag: '🇸🇸'),
    Country(code: 'ES', name: 'Spain', dialCode: '+34', flag: '🇪🇸'),
    Country(code: 'LK', name: 'Sri Lanka', dialCode: '+94', flag: '🇱🇰'),
    Country(code: 'SD', name: 'Sudan', dialCode: '+249', flag: '🇸🇩'),
    Country(code: 'SR', name: 'Suriname', dialCode: '+597', flag: '🇸🇷'),
    Country(code: 'SE', name: 'Sweden', dialCode: '+46', flag: '🇸🇪'),
    Country(code: 'CH', name: 'Switzerland', dialCode: '+41', flag: '🇨🇭'),
    Country(code: 'SY', name: 'Syria', dialCode: '+963', flag: '🇸🇾'),
    
    // T
    Country(code: 'TJ', name: 'Tajikistan', dialCode: '+992', flag: '🇹🇯'),
    Country(code: 'TZ', name: 'Tanzania', dialCode: '+255', flag: '🇹🇿'),
    Country(code: 'TH', name: 'Thailand', dialCode: '+66', flag: '🇹🇭'),
    Country(code: 'TL', name: 'Timor-Leste', dialCode: '+670', flag: '🇹🇱'),
    Country(code: 'TG', name: 'Togo', dialCode: '+228', flag: '🇹🇬'),
    Country(code: 'TO', name: 'Tonga', dialCode: '+676', flag: '🇹🇴'),
    Country(code: 'TT', name: 'Trinidad and Tobago', dialCode: '+1', flag: '🇹🇹'),
    Country(code: 'TN', name: 'Tunisia', dialCode: '+216', flag: '🇹🇳'),
    Country(code: 'TR', name: 'Turkey', dialCode: '+90', flag: '🇹🇷'),
    Country(code: 'TM', name: 'Turkmenistan', dialCode: '+993', flag: '🇹🇲'),
    Country(code: 'TV', name: 'Tuvalu', dialCode: '+688', flag: '🇹🇻'),
    Country(code: 'TW', name: 'Taiwan', dialCode: '+886', flag: '🇹🇼'),
    
    // U
    Country(code: 'UG', name: 'Uganda', dialCode: '+256', flag: '🇺🇬'),
    Country(code: 'UA', name: 'Ukraine', dialCode: '+380', flag: '🇺🇦'),
    Country(code: 'AE', name: 'United Arab Emirates', dialCode: '+971', flag: '🇦🇪'),
    Country(code: 'GB', name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧'),
    Country(code: 'US', name: 'United States', dialCode: '+1', flag: '🇺🇸'),
    Country(code: 'UY', name: 'Uruguay', dialCode: '+598', flag: '🇺🇾'),
    Country(code: 'UZ', name: 'Uzbekistan', dialCode: '+998', flag: '🇺🇿'),
    
    // V
    Country(code: 'VU', name: 'Vanuatu', dialCode: '+678', flag: '🇻🇺'),
    Country(code: 'VA', name: 'Vatican City', dialCode: '+379', flag: '🇻🇦'),
    Country(code: 'VE', name: 'Venezuela', dialCode: '+58', flag: '🇻🇪'),
    Country(code: 'VN', name: 'Vietnam', dialCode: '+84', flag: '🇻🇳'),
    
    // Y
    Country(code: 'YE', name: 'Yemen', dialCode: '+967', flag: '🇾🇪'),
    
    // Z
    Country(code: 'ZM', name: 'Zambia', dialCode: '+260', flag: '🇿🇲'),
    Country(code: 'ZW', name: 'Zimbabwe', dialCode: '+263', flag: '🇿🇼'),
    
    // 特殊地區
    Country(code: 'HK', name: 'Hong Kong', dialCode: '+852', flag: '🇭🇰'),
    Country(code: 'MO', name: 'Macau', dialCode: '+853', flag: '🇲🇴'),
  ];

  /// 根據國家代碼查找國家
  static Country? findByCode(String code) {
    try {
      return all.firstWhere((country) => 
          country.code.toLowerCase() == code.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  /// 根據名稱搜尋國家
  static List<Country> searchByName(String query) {
    if (query.isEmpty) return all;
    
    final lowercaseQuery = query.toLowerCase();
    return all.where((country) {
      return country.name.toLowerCase().contains(lowercaseQuery) ||
             country.code.toLowerCase().contains(lowercaseQuery) ||
             country.dialCode.contains(query);
    }).toList();
  }
}