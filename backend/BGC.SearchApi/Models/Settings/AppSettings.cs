using System.Diagnostics.CodeAnalysis;

using BGC.SearchApi.Policies;

namespace BGC.SearchApi.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record AppSettings
    {
        public MongoDbSettings? MongoDb { get; init; }

        public ApiKeyAuthenticationSettings? ApiKeyAuthenticationSettings { get; init; }
    }
}
