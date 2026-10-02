String toArabicNumerals(Object input) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  String text = input.toString();
  for (int i = 0; i < western.length; i++) {
    text = text.replaceAll(western[i], arabic[i]);
  }
  return text;
}