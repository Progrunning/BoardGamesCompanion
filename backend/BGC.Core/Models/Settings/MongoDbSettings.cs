using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace BGC.Core.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record MongoDbSettings
    {
        /// <summary>
        /// Gets connection string.
        /// </summary>
        [Required]
        public string ConnectionString { get; init; } = null!;
    }
}
