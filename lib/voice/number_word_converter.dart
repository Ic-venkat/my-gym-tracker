/// Converts spoken number words and compound phrases into digit strings.
class NumberWordConverter {
  NumberWordConverter._();

  static const Map<String, int> _units = <String, int>{
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'eleven': 11,
    'twelve': 12,
    'thirteen': 13,
    'fourteen': 14,
    'fifteen': 15,
    'sixteen': 16,
    'seventeen': 17,
    'eighteen': 18,
    'nineteen': 19,
  };

  static const Map<String, int> _tens = <String, int>{
    'twenty': 20,
    'thirty': 30,
    'forty': 40,
    'fifty': 50,
    'sixty': 60,
    'seventy': 70,
    'eighty': 80,
    'ninety': 90,
  };

  /// Normalizes spoken numbers including compound tens and decimals.
  static String convert(String text) {
    // 1. Spoken decimals: "two point five" -> "2.5"
    String result = text.replaceAllMapped(
      RegExp(r'\b([a-z]+)\s+point\s+([a-z]+)\b'),
      (Match m) {
        final int? whole = _units[m.group(1)] ?? _tens[m.group(1)];
        final int? dec = _units[m.group(2)];
        if (whole != null && dec != null) {
          return '$whole.$dec';
        }
        return m.group(0)!;
      },
    );

    // 2. Compound numbers: "twenty five" -> "25", "eighty five" -> "85"
    result = result.replaceAllMapped(
      RegExp(
        r'\b(twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety)\s+(one|two|three|four|five|six|seven|eight|nine)\b',
      ),
      (Match m) {
        final int t = _tens[m.group(1)] ?? 0;
        final int u = _units[m.group(2)] ?? 0;
        return (t + u).toString();
      },
    );

    // 3. Hundreds: "one hundred" -> "100", "two hundred" -> "200"
    result = result.replaceAllMapped(
      RegExp(r'\b(one|two|three|four|five|six|seven|eight|nine)\s+hundred\b'),
      (Match m) {
        final int u = _units[m.group(1)] ?? 1;
        return (u * 100).toString();
      },
    );

    // 4. Standalone words: "five" -> "5", "twenty" -> "20", "hundred" -> "100"
    final List<String> words = result.split(' ');
    final List<String> mapped = words.map((String word) {
      if (_units.containsKey(word)) return _units[word].toString();
      if (_tens.containsKey(word)) return _tens[word].toString();
      if (word == 'hundred') return '100';
      return word;
    }).toList();

    return mapped.join(' ');
  }
}
