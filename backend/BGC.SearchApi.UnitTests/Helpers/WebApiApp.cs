using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;

namespace BGC.SearchApi.UnitTests.Helpers
{
    public sealed class WebApiApp : WebApplicationFactory<Program>
    {
        public const string ApiKey = "apiKey";
        public const string CacheConnectionString = "connectionString";
        public const string CacheQueueName = "queueName";
        public const string CacheSendConnectionString = "sendConnectionString";
        public const string MongoDbConnectionString = "mongoDbConnectionString";

        protected override IHost CreateHost(IHostBuilder builder)
        {
            builder.ConfigureHostConfiguration((configBuilder) =>
            {
                configBuilder.Sources.Clear();
#pragma warning disable CS8620 // Argument cannot be used for parameter due to differences in the nullability of reference types.
                configBuilder.AddInMemoryCollection(new Dictionary<string, string>
                {
                    { "AppSettings:CacheSettings:ConnectionString", CacheConnectionString },
                    { "AppSettings:CacheSettings:QueueName", CacheQueueName },
                    { "AppSettings:CacheSettings:SendConnectionString", CacheSendConnectionString },
                    { "AppSettings:ApiKeyAuthenticationSettings:ApiKey", ApiKey },
                    { "AppSettings:MongoDbSettings:ConnectionString", MongoDbConnectionString },
                });
#pragma warning restore CS8620 // Argument cannot be used for parameter due to differences in the nullability of reference types.
            });

            return base.CreateHost(builder);
        }
    }
}
