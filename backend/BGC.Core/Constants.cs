namespace BGC.Core
{
    public static class Constants
    {
        public static class MongoDb
        {
            public const string BgcDbName = "boardGames";
            public const string BoardGamesDbCollectionName = "bgg";

            public static class ConventionNames
            {
                public const string CamelCase = "camelCase";
            }
        }

        public static class BggApi
        {
            public const string BaseUrl = "https://boardgamegeek.com";
            public const string BaseXmlApiUrl = $"{BaseUrl}/xmlapi2";
        }

        public static class BoardGameOracleApi
        {
            public const string BaseUrl = "https://api.boardgameoracle.com";
        }
    }
}
