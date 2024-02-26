using BGC.CacheCore.Helpers;
using BGC.CacheCore.Interfaces;
using BGC.Core.Extensions;
using BGC.Core.Models.Settings;
using BGC.UpdateBoardGameCacheWorker;
using BGC.UpdateBoardGameCacheWorker.Services;

var host = Host.CreateDefaultBuilder(args)
    .ConfigureAppConfiguration((hostingContext, configBuilder) =>
    {
        configBuilder.AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: false);
    })
    .ConfigureServices(services =>
    {        
        services.AddUpdateBoardGameCacheWorkerConfiguration();
        services.AddOptions<CacheServiceBusSettings>()
                .Configure<IConfiguration>((settings, configuration) =>
                {
                    configuration.GetSection(nameof(CacheServiceBusSettings))
                                 .Bind(settings);
                })
                .ValidateDataAnnotations()
                .ValidateOnStart();
        services.AddSingleton<IUpdateBoardGameCacheService, UpdateBoardGameCacheService>();
        services.AddHostedService<Worker>();
    })
    .Build();

MongoDbHelpers.RegisterConventions();

await host.RunAsync();
