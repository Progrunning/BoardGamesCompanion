using System.Diagnostics.CodeAnalysis;

using BGC.Core.Models.Settings;
using BGC.SearchApi.Policies;

namespace BGC.SearchApi.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record AppSettings
    {
        /// <summary>
        /// Gets board games database.
        /// </summary>
        public MongoDbSettings? MongoDb { get; init; }

        /// <summary>
        /// Gets auth settings.
        /// </summary>
        public ApiKeyAuthenticationSettings? ApiKeyAuthenticationSettings { get; init; }
    }
}
