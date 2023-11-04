using System.Text.Json;

using Amazon.Runtime.Internal;

using Azure.Messaging.ServiceBus;

using BGC.CacheCore.Interfaces;
using BGC.Core.Models.Settings;

using Microsoft.Extensions.Options;

namespace BGC.UpdateBoardGameCacheWorker;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly IUpdateBoardGameCacheService _updateBoardGameCache;
    private readonly CacheServiceBusSettings _cacheServiceBusSettings;

    public Worker(
        ILogger<Worker> logger,
        IUpdateBoardGameCacheService updateBoardGameCache,
        IOptions<CacheServiceBusSettings> cacheServiceBusSettings)
    {
        _logger = logger;
        _updateBoardGameCache = updateBoardGameCache;
        _cacheServiceBusSettings = cacheServiceBusSettings.Value;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var listenPolicyPermissionsClient = new ServiceBusClient(_cacheServiceBusSettings.ListenConnectionString);
        await using var serviceBusProcessor = listenPolicyPermissionsClient.CreateProcessor(_cacheServiceBusSettings.QueueName, new ServiceBusProcessorOptions
        {
            AutoCompleteMessages = true,
            // Using only 1 concurrent call to avoid issues with BGG rate limitation
            // After a large amount of API calls in a short span of time BGG blocks the IP
            MaxConcurrentCalls = 1
        });
        serviceBusProcessor.ProcessMessageAsync += ProcessMessage;
        serviceBusProcessor.ProcessErrorAsync += ProcessError;

        await serviceBusProcessor.StartProcessingAsync();

        // Run the worker indefinitely
        while (!stoppingToken.IsCancellationRequested)
        {
            _logger.LogInformation("Heartbeat {time}", DateTimeOffset.Now);
            await Task.Delay(10_000, stoppingToken);
        }
    }

    private async Task ProcessMessage(ProcessMessageEventArgs args)
    {
        await _updateBoardGameCache.ProcessUpdateCacheMessage(args.Message);
    }

    private Task ProcessError(ProcessErrorEventArgs args)
    {
        _logger.LogError($"Failed to process a message with an error {args.Exception.Message}");
        return Task.CompletedTask;
    }
}
