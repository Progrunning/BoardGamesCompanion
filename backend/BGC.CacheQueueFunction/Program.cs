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

// TODO Use Azure App Configuration https://learn.microsoft.com/en-us/azure/azure-app-configuration/enable-dynamic-configuration-azure-functions-csharp?tabs=isolated-process

var host = new HostBuilder()
    .ConfigureAppConfiguration((hostingContext, configBuilder) =>
    {
        configBuilder.AddJsonFile("local.settings.json", optional: true, reloadOnChange: false);
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
        });
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
