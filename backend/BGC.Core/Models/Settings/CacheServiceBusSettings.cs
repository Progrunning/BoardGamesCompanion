using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace BGC.Core.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record CacheServiceBusSettings
    {
        /// <summary>
        /// Gets service bus connection string.
        /// </summary>
        [Required]
        public required string ListenConnectionString { get; init; }

        /// <summary>
        /// Gets queue name.
        /// </summary>
        [Required]
        public required string QueueName { get; init; }
    }
}
