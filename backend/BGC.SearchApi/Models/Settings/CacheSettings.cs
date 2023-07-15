using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace BGC.SearchApi.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record CacheSettings
    {
        /// <summary>
        /// Gets connection string.
        /// </summary>
        [Required]
        public string ConnectionString { get; init; } = null!;

        /// <summary>
        /// Gets queue name.
        /// </summary>
        [Required]
        public string QueueName { get; init; } = null!;
    }
}
