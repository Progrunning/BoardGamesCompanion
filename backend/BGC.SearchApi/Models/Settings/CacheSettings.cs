using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace BGC.SearchApi.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record CacheSettings
    {
        /// <summary>
        /// Gets connection string for sending messages.
        /// </summary>
        [Required]
        public string SendConnectionString { get; init; } = null!;

        /// <summary>
        /// Gets queue name.
        /// </summary>
        [Required]
        public string QueueName { get; init; } = null!;

        /// <summary>
        /// Gets expiration date on the cached games.
        /// </summary>
        /// <remarks>Defaults to one week.</remarks>
        [Required]
        public int CacheExpirationInMinutes { get; init; } = 10080;
    }
}
