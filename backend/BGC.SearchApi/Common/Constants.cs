using System.Diagnostics.CodeAnalysis;

namespace BGC.SearchApi.Common;

[SuppressMessage("StyleCop.CSharp.DocumentationRules", "SA1600:ElementsMustBeDocumented", Justification = "No need to document constants, as their names should be self explanatory")]
public static class Constants
{
    public static class ConfigurationKeyNames
    {
        public const string IsIntegrationTest = "IntegrationTest";
        public const string KeyVault = "KeyVaultName";
    }

    public static class Headers
    {
        public const string ApiKey = "x-api-key";
    }

    public static class AuthenticationSchemes
    {
        public const string ApiKey = nameof(ApiKey);
    }
}
