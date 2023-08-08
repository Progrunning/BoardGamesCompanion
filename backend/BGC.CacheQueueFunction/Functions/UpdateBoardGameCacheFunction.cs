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
using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.CacheQueueFunction.Functions
{
    public class UpdateBoardGameCacheFunction
    {
        private readonly ILogger _logger;
        private readonly IBggService _bggService;
        private readonly IBoardGamesRepository _boardGamesRepository;
        private readonly IBoardGameOracleService _boardGameOracleService;

        public UpdateBoardGameCacheFunction(
            ILoggerFactory loggerFactory,
            IBggService bggService,
            IBoardGamesRepository boardGamesRepository,
            IBoardGameOracleService boardGameOracleService)
        {
            _logger = loggerFactory.CreateLogger<UpdateBoardGameCacheFunction>();
            _bggService = bggService;
            _boardGamesRepository = boardGamesRepository;
            _boardGameOracleService = boardGameOracleService;
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

                _logger.LogInformation($"Updating cache of a board game {boardGameToCache.BoardGameId}...");
                _logger.LogInformation($"Retrieveing board game {boardGameToCache.BoardGameId} details.");
                var boardGameDetailsDto = await _bggService.GetDetails(boardGameToCache.BoardGameId, CancellationToken.None);
                if (boardGameDetailsDto is null)
                {
                    throw new BoardGameNotFoundException();
                }

                _logger.LogInformation($"Converting board game dto to domain model.");
                var regionalPriceStatistics = await RetrieveRegionalPriceStatistics(boardGameToCache);                

                var boardGame = boardGameDetailsDto!.ToDomain(regionalPriceStatistics);

                _logger.LogInformation($"Upserting board game details {boardGame}");
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

        private async Task<IReadOnlyCollection<PriceStatisticsDto>> RetrieveRegionalPriceStatistics(CacheBoardGameMessage boardGameToCache)
        {
            var regionalPriceStatisticsTasks = new List<Task<PriceStatisticsDto?>>();
            foreach (RegionDto regionDto in Enum.GetValues(typeof(RegionDto)))
            {
                regionalPriceStatisticsTasks.Add(_boardGameOracleService.GetPriceStats(boardGameToCache.BoardGameId, regionDto));
            }

            var regionalPriceStatistics = await Task.WhenAll(regionalPriceStatisticsTasks);
            if (regionalPriceStatistics is null)
            {
                return Array.Empty<PriceStatisticsDto>();
            }

            return regionalPriceStatistics.Where(rps => rps is not null).OfType<PriceStatisticsDto>().ToArray();
        }
    }
}
