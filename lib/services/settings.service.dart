class SettingsService {
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() => _instance;

  SettingsService._internal();

  Map? settings;

  set setSettings(Map? value) => settings = value;

  void removeSettings() => settings = null;
}
