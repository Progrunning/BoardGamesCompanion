using BGC.Core.Services.Interfaces;
using BGC.Core.Services;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using BGC.Core;


var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults(builder => { }, options =>
    {
        options.EnableUserCodeException = true;
    })
    .ConfigureServices(services =>
    {
        services.AddTransient<IBggService, BggService>();
        services.AddHttpClient<IBggService, BggService>(client =>
        {
            client.BaseAddress = new Uri(Constants.BggApi.BaseUrl);
        });
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

await host.RunAsync();
