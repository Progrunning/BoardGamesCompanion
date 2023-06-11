using System.Security.Claims;
using System.Text.Encodings.Web;

using BGC.SearchApi.Common;

using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace BGC.SearchApi.Policies
{
    /// <summary>
    /// Handler for the API key check.
    /// </summary>
    public class ApiKeyAuthenticationHandler : AuthenticationHandler<ApiKeyAuthenticationSettings>
    {
        private readonly ApiKeyAuthenticationSettings _options;

        /// <summary>
        /// Initializes a new instance of the <see cref="ApiKeyAuthenticationHandler"/> class.
        /// </summary>
        /// <param name="options"></param>
        /// <param name="logger"></param>
        /// <param name="encoder"></param>
        /// <param name="clock"></param>
        public ApiKeyAuthenticationHandler(IOptionsMonitor<ApiKeyAuthenticationSettings> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock)
            : base(options, logger, encoder, clock)
        {
            _options = options.CurrentValue;
        }

        /// <inheritdoc/>
        protected override Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Context.Request.Headers.TryGetValue(Constants.Headers.ApiKey, out var apiKey))
            {
                var failureMessage = "Api key not provided";
                Logger.LogWarning(failureMessage);
                return Task.FromResult(AuthenticateResult.Fail(failureMessage));
            }

            if (!string.Equals(_options.ApiKey, apiKey, StringComparison.Ordinal))
            {
                var failureMessage = "Incorrect api key used";
                Logger.LogWarning(failureMessage);
                return Task.FromResult(AuthenticateResult.Fail(failureMessage));
            }

            var claims = new[] { new Claim(ClaimTypes.Name, "User with valid Api Key") };
            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return Task.FromResult(AuthenticateResult.Success(ticket));
        }
    }
}
