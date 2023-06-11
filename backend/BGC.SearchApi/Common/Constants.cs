using System.Diagnostics.CodeAnalysis;

namespace BGC.SearchApi.Common;

[SuppressMessage("StyleCop.CSharp.DocumentationRules", "SA1600:ElementsMustBeDocumented", Justification = "No need to document constants, as their names should be self explanatory")]
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

    public static class Headers
    {
        public const string ApiKey = "x-api-key";
    }

    public static class AuthenticationSchemes
    {
        public const string ApiKey = nameof(ApiKey);
    }
}
