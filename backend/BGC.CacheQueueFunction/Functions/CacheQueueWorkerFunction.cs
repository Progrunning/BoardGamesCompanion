using System.Text.Json;

using Azure.Messaging.ServiceBus;

using BGC.CacheQueueFunction.Models;
using BGC.CacheQueueFunction.Models.Exceptions;
using BGC.Core.Services.Interfaces;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.WebJobs.ServiceBus;
using Microsoft.Extensions.Logging;

namespace BGC.CacheQueueFunction.Functions
{
    public class CacheQueueWorkerFunction
    {
        private readonly ILogger _logger;
        private readonly IBggService _bggService;

        public CacheQueueWorkerFunction(ILoggerFactory loggerFactory, IBggService bggService)
        {
            _logger = loggerFactory.CreateLogger<CacheQueueWorkerFunction>();
            _bggService = bggService;
        }

        // https://github.com/Azure/azure-functions-dotnet-worker/issues/226
        [Function(nameof(CacheQueueWorkerFunction))]
        public async Task Run([ServiceBusTrigger(Constants.Configruration.Names.CacheQueueName, Connection = Constants.Configruration.Names.CacheQueueConnectionString)]
            ServiceBusReceivedMessage queueMessage,
            ServiceBusMessageActions messageActions)
        {
            try
            {
                var boardGameToCache = await JsonSerializer.DeserializeAsync<CacheBoardGameMessage>(queueMessage.Body.ToStream());
                if (string.IsNullOrWhiteSpace(boardGameToCache?.BoardGameId))
                {
                    throw new ValidationException();
                }

                _logger.LogInformation($"Caching a board game {boardGameToCache.BoardGameId}...");

                var boardGameDetails = await _bggService.GetDetails(boardGameToCache.BoardGameId, CancellationToken.None);
            }
            catch (Exception ex)
            {
                switch (ex)
                {
                    case ValidationException validationException:
                    case JsonException jsonException:
                        await messageActions.DeadLetterMessageAsync(queueMessage, "Failed to parse the message");
                        break;
                    default:
                        break;
                }
            }

        }
    }
}
