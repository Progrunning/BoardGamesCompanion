using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using BGC.Core.Extensions;
using Microsoft.Extensions.Configuration;
using BGC.CacheCore.Helpers;

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
        services.AddUpdateBoardGameCacheWorkerConfiguration();
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
    })
    .ConfigureLogging(logging =>
    {
        logging.AddConsole();
        logging.AddFilter("System.Net.Http.HttpClient", LogLevel.Warning);
    })
    .Build();

MongoDbHelpers.RegisterConventions();

await host.RunAsync();