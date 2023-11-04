using BGC.Core.Models.Settings;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Repositories;
using BGC.Core.Services.Interfaces;
using BGC.Core.Services;

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

using MongoDB.Driver;
using Polly;
using Polly.Extensions.Http;

namespace BGC.Core.Extensions
{
    public static class ServiceConnectionExtensions
    {
        public static void AddUpdateBoardGameCacheWorkerConfiguration(this IServiceCollection services)
        {
            services.AddOptions<MongoDbSettings>()
                .Configure<IConfiguration>((settings, configuration) =>
                {
                    configuration.GetSection(nameof(MongoDbSettings))
                                 .Bind(settings);
                })
                .ValidateDataAnnotations()
                .ValidateOnStart();

            services.AddTransient<IBggService, BggService>();
            services.AddHttpClient<IBggService, BggService>(client =>
            {
                client.BaseAddress = new Uri(Constants.BggApi.BaseXmlApiUrl);
                client.Timeout = Constants.BggApi.Timeout;
            }).AddPolicyHandler(GetRetryPolicy());
            services.AddHttpClient<IBoardGameOracleService, BoardGameOracelService>(client =>
            {
                client.BaseAddress = new Uri(Constants.BoardGameOracleApi.BaseUrl);
                client.Timeout = Constants.BoardGameOracleApi.Timeout;
            }).AddPolicyHandler(GetRetryPolicy());
            services.AddTransient<IMongoClient>((services) =>
            {
                var mongoDbSettings = services.GetService<IOptions<MongoDbSettings>>();
                return new MongoClient(mongoDbSettings!.Value.ConnectionString);
            });
            services.AddTransient<IBoardGamesRepository, BoardGamesRepository>();
            services.AddHttpClient();
        }

        private static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
        {
            return HttpPolicyExtensions
                .HandleTransientHttpError()
                .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));
        }
    }
}
