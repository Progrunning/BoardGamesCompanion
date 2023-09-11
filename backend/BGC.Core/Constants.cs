namespace BGC.Core
{
    public static class Constants
    {
        public static class Domain
        {
            public static class BoardGameTypes
            {
                public const string MainGame = "boardgame";
                public const string Expansion = "expansion";
            }
        }

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

            public static class NamedEntities
            {
                public const string Artists = "boardgameartist";
                public const string Publisher = "boardgamepublisher";
                public const string Category = "boardgamecategory";
                public const string Mechanic = "boardgamemechanic";
                public const string Designer = "boardgamedesigner";
                public const string Expansion = "boardgameexpansion";
            }

            public static class BoardGameTypes
            {
                public const string MainGame = "boardgame";
                public const string Expansion = "boardgameexpansion";
            }
        }

        public static class BoardGameOracleApi
        {
            public const string BaseUrl = "https://api.boardgameoracle.com";
        }
    }
}
