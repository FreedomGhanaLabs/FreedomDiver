String getOrdinal(int number) {
  if (number < 1) return number.toString(); // edge case

  final suffix =
      (number % 100 >= 11 && number % 100 <= 13)
          ? 'th'
          : {1: 'st', 2: 'nd', 3: 'rd'}[number % 10] ?? 'th';

  return '$number$suffix';
}
