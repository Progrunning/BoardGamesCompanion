using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;

namespace BGC.SearchApi.UnitTests.Helpers
{
    public sealed class WebApiApp : WebApplicationFactory<Program>
    {
        public const string ApiKey = "apiKey";
        public const string MongoDbConnectionString = "mongoDbConnectionString";

        protected override IHost CreateHost(IHostBuilder builder)
        {
            builder.ConfigureHostConfiguration((configBuilder) =>
            {
                configBuilder.Sources.Clear();
                configBuilder.AddInMemoryCollection(new Dictionary<string, string>
                {
                    { "AppSettings:ApiKeyAuthenticationSettings:ApiKey", ApiKey },
                    { "AppSettings:MongoDbSettings:ConnectionString", MongoDbConnectionString },
                });
            });

            return base.CreateHost(builder);
        }
    }
}
