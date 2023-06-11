using System.ComponentModel.DataAnnotations;

using Microsoft.AspNetCore.Authentication;

namespace BGC.SearchApi.Policies
{
    /// <summary>
    /// Api key authentication settings.
    /// </summary>
    public class ApiKeyAuthenticationSettings : AuthenticationSchemeOptions
    {
        /// <summary>
        /// Gets api key.
        /// </summary>
        [Required]
        public string ApiKey { get; init; }
    }
}
