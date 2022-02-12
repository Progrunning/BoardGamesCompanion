class Constants {
  static const BoardGameRatingNumberOfDecimalPlaces = 1;

  static const ShortMonthDateFormat = 'MMM';
  static const ShortWeekDayDateFormat = 'E';

  static const Top100 = 100;
  static const double BoardGameDetailsImageHeight = 300;

  static const FeedbackEmailAddress = 'feedback@progrunning.net';
  static const BoardGameGeekBaseUrl = 'https://www.boardgamegeek.com/';
  static const BoardGameGeekBaseApiUrl = BoardGameGeekBaseUrl;

  static const BoardGameGeekLastModifiedDateTimeFormat = 'yyyy-mm-dd HH:MM:ss';

  static const BoardGameOracleBaseUrl = 'https://www.boardgameoracle.com/';
  static const BoardGameOracleUsaCultureName = 'en-US';
  static const BoardGameOracleNewZealandCultureName = 'en-NZ';
  static const BoardGameOracleAustraliaCultureName = 'en-AU';
  static const BoardGameOracleCanadaCultureName = 'en-CA';
  static const Set<String> BoardGameOracleSupportedCultureNames = {
    BoardGameOracleUsaCultureName,
    BoardGameOracleNewZealandCultureName,
    BoardGameOracleAustraliaCultureName,
    BoardGameOracleCanadaCultureName
  };

  static const UsaCountryCode = 'US';

  static const LeaveAsIs = 0;
  static const MoveBelow = 1;
  static const MoveAbove = -1;

  static const DefaultAvatartAssetsPath = 'assets/default_avatar.png';

  static const String FilterByAny = 'any';

  static const String AppleAppId = '1506458832';

  static const int DaysInYear = 365;
  static const int DaysInTenYears = DaysInYear * 10;

  static const int maxNumberOfPlayers = 20;

  static const int fullCricleDegrees = 360;
}
