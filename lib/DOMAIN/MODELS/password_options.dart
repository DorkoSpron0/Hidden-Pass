class PasswordOptions {
  bool includeUppercase;
  bool includeLowercase;
  bool includeNumbers;
  bool includeSymbols;
  int length;

  PasswordOptions({
    this.includeUppercase = false,
    this.includeLowercase = false,
    this.includeNumbers = false,
    this.includeSymbols = false,
    this.length = 8,
  });
}