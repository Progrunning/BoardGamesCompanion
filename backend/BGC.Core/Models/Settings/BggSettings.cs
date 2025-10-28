using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace BGC.Core.Models.Settings
{
    [ExcludeFromCodeCoverage(Justification = "Settings model don't require testing")]
    public record BggSettings
    {
        /// <summary>
        /// Gets authorization token.
        /// </summary>
        [Required(ErrorMessage = "BGG authorization token is required to call XML APIs")]
        public string AuthToken { get; init; } = null!;
    }
}
