using System.Text.Json;

using Azure.Messaging.ServiceBus;

using BGC.CacheQueueFunction.Models;
using BGC.CacheQueueFunction.Models.Exceptions;
using BGC.Core.Models.Exceptions;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services.Interfaces;
using BGC.Core.Extensions;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace BGC.CacheQueueFunction.Functions
{
    public class UpdateBoardGameCacheFunction
    {
        private readonly ILogger _logger;
        private readonly IBggService _bggService;
        private readonly IBoardGamesRepository _boardGamesRepository;

        public UpdateBoardGameCacheFunction(ILoggerFactory loggerFactory, IBggService bggService, IBoardGamesRepository boardGamesRepository)
        {
            _logger = loggerFactory.CreateLogger<UpdateBoardGameCacheFunction>();
            _bggService = bggService;
            _boardGamesRepository = boardGamesRepository;
        }

        [Function(nameof(UpdateBoardGameCacheFunction))]
        public async Task Run([ServiceBusTrigger(Constants.Configruration.Names.CacheQueueName, Connection = Constants.Configruration.Names.CacheQueueConnectionString)]
            ServiceBusReceivedMessage queueMessage)
        {
            try
            {
                var boardGameToCache = await JsonSerializer.DeserializeAsync<CacheBoardGameMessage>(queueMessage.Body.ToStream(), Constants.CustomJsonSerializerOptions);
                if (string.IsNullOrWhiteSpace(boardGameToCache?.BoardGameId))
                {
                    throw new ValidationException();
                }

                _logger.LogInformation($"Caching a board game {boardGameToCache.BoardGameId}...");

                var boardGameDetailsDto = await _bggService.GetDetails(boardGameToCache.BoardGameId, CancellationToken.None);
                if (boardGameDetailsDto is null)
                {
                    throw new BoardGameNotFoundException();
                }

                var boardGame = boardGameDetailsDto!.ToDomain();
                await _boardGamesRepository.UpsertBoardGame(boardGame, CancellationToken.None);
            }
            catch (Exception ex)
            {
                switch (ex)
                {
                    case InvalidOperationException invalidOperationException:
                        _logger.LogError(invalidOperationException, $"XML parsing failure.");
                        break;
                    case ValidationException validationException:
                    case JsonException jsonException:
                        _logger.LogError(ex, $"Failed to process update cache message due to validation or parsing issue.");
                        // TODO Observe this space for package updates to get the message ServiceBusMessageActions available
                        // https://github.com/Azure/azure-functions-dotnet-worker/issues/226
                        // https://github.com/Azure/azure-functions-dotnet-worker/releases
                        //await messageActions.DeadLetterMessageAsync(queueMessage, "Failed to parse the message");
                        break;
                    default:
                        _logger.LogError(ex, $"Processing of update cache message failed.");
                        break;
                }

                // MK Added to enforce re-try and dead-lettering after reaching max rety count
                throw;
            }

        }
    }
}
