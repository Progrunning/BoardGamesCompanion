﻿namespace BGC.SearchApi.Common;

public static class Constants
{
    public static class BggApi
    {
        public const string BaseUrl = "https://boardgamegeek.com/xmlapi2";
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
}
