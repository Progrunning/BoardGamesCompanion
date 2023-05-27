using System.Diagnostics.CodeAnalysis;

namespace BGC.SearchApi.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record MongoDbSettings
    {
        public string? ConnectionString { get; init; }
    }
}
