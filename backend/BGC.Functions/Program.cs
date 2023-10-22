using BGC.Core.Services.Interfaces;
using BGC.Core.Services;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using BGC.Core;
using MongoDB.Bson.Serialization.Conventions;
using BGC.Core.Models.Settings;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Repositories;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using Microsoft.Extensions.Configuration;
using Polly.Extensions.Http;
using Polly;

// TODO Use Azure App Configuration https://learn.microsoft.com/en-us/azure/azure-app-configuration/enable-dynamic-configuration-azure-functions-csharp?tabs=isolated-process

var host = new HostBuilder()
    .ConfigureAppConfiguration((hostingContext, configBuilder) =>
    {
    // Added conditional code because there seems to be an issue with Azure Functions / Azure Storage
    // where a lot of sotrage transactions is being made for no good reason, which increases the cost of subscription.
    // The below are links with some information / explanation of the problem

    // https://stackoverflow.com/questions/60114152/inexplicable-storage-transactions-from-azure-functions
    // https://stackoverflow.com/a/60484059/510627
#if DEBUG
        configBuilder.AddJsonFile("local.settings.json", optional: true, reloadOnChange: false);
#endif
    })
    .ConfigureFunctionsWorkerDefaults(builder => { }, options =>
    {
        options.EnableUserCodeException = true;
    })
    .ConfigureServices(services =>
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
            client.Timeout = BGC.CacheQueueFunction.Constants.Configruration.Http.Timeout;
        }).AddPolicyHandler(GetRetryPolicy());
        services.AddHttpClient<IBoardGameOracleService, BoardGameOracelService>(client =>
        {
            client.BaseAddress = new Uri(Constants.BoardGameOracleApi.BaseUrl);
            client.Timeout = BGC.CacheQueueFunction.Constants.Configruration.Http.Timeout;
        }).AddPolicyHandler(GetRetryPolicy());
        services.AddTransient<IMongoClient>((services) =>
        {
            var mongoDbSettings = services.GetService<IOptions<MongoDbSettings>>();
            return new MongoClient(mongoDbSettings!.Value.ConnectionString);
        });
        services.AddTransient<IBoardGamesRepository, BoardGamesRepository>();
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
        services.AddHttpClient();
    })
    .ConfigureLogging(logging =>
    {
        logging.AddConsole();
        logging.AddFilter("System.Net.Http.HttpClient", LogLevel.Warning);
    })
    .Build();

var mongoDbConventionPack = new ConventionPack
{
    new CamelCaseElementNameConvention(),
};
ConventionRegistry.Register(Constants.MongoDb.ConventionNames.CamelCase, mongoDbConventionPack, type => true);

await host.RunAsync();


static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));
}