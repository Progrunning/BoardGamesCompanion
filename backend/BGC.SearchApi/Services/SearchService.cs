using System.Net;

using BGC.Core;
using BGC.Core.Models.Domain;
using BGC.Core.Models.Dtos.BoardGameGeek;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services.Interfaces;
using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

namespace BGC.SearchApi.Services;

/// <inheritdoc />
public class SearchService : ISearchService
{
    private readonly ILogger<SearchService> _logger;
    private readonly IBggService _bggService;
    private readonly IBoardGamesRepository _boardGamesRepository;
    private readonly ICacheService _cacheService;
    private readonly IDateTimeService _dateTimeService;

    /// <summary>
    /// Initializes a new instance of the <see cref="SearchService"/> class.
    /// </summary>
    /// <param name="logger"></param>
    /// <param name="bggService"></param>
    /// <param name="boardGamesRepository"></param>
    /// <param name="cacheService"></param>
    /// <param name="dateTimeService"></param>
    public SearchService(ILogger<SearchService> logger, IBggService bggService, IBoardGamesRepository boardGamesRepository, ICacheService cacheService, IDateTimeService dateTimeService)
    {
        _logger = logger;
        _bggService = bggService;
        _boardGamesRepository = boardGamesRepository;
        _cacheService = cacheService;
        _dateTimeService = dateTimeService;
    }

    /// <inheritdoc />
    public async Task<IReadOnlyCollection<BoardGameSummaryDto>> Search(string query, CancellationToken cancellationToken)
    {
        try
        {
            var bggSearchResponse = await _bggService.Search(query, cancellationToken);
            if (bggSearchResponse.IsEmpty)
            {
                return Array.Empty<BoardGameSummaryDto>();
            }

            var boardGameSummaries = bggSearchResponse.BoardGames.Select(boardGame => new BoardGameSummaryDto(boardGame.Id.ToString(), boardGame.Name.Value, boardGame.YearPublished?.Value))
                                                                 .ToArray();

            var boardGamesDetails = await _boardGamesRepository.GetBoardGames(boardGameSummaries.Select(boardGame => boardGame.Id), cancellationToken);
            var boardGamesDetailsDict = boardGamesDetails.ToDictionary(boardGame => boardGame.Id);

            EnrichBoardGameDetails(boardGameSummaries, boardGamesDetailsDict);

#pragma warning disable CS4014 // Intentionally not awaiting this call, as it should be done in the background
            CacheBoardGames(boardGameSummaries, boardGamesDetailsDict);
#pragma warning restore CS4014 // Intentionally not awaiting this call, as it should be done in the background

            return boardGameSummaries;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Search failed");

            throw new BggException((int)HttpStatusCode.InternalServerError, "Search failed");
        }
    }

    /// <summary>
    /// This method has been implemented to ensure that the returned type of the board game is "expension" rather than "boardgameexpansion"
    /// for the app's backward compatibility. Once everyone goes beyond version of the app 1.11.4 this could potentially be removed.
    /// </summary>
    /// <param name="boardGame"></param>
    /// <returns>App safe version of the board game type.</returns>
    private static string RetrieveBoardGameDomainType(BoardGame boardGame)
    {
        switch (boardGame.Type.ToLowerInvariant())
        {
            case Constants.BggApi.BoardGameTypes.MainGame:
                return Constants.Domain.BoardGameTypes.MainGame;
            case Constants.BggApi.BoardGameTypes.Expansion:
                return Constants.Domain.BoardGameTypes.Expansion;
            default:
                return Constants.Domain.BoardGameTypes.MainGame;
        }
    }

    private void EnrichBoardGameDetails(IReadOnlyCollection<BoardGameSummaryDto> boardGames, IDictionary<string, BoardGame> boardGamesDetailsDict)
    {
        try
        {
            foreach (var boardGame in boardGames)
            {
                if (!boardGamesDetailsDict.TryGetValue(boardGame.Id, out var boardGameDetails))
                {
                    continue;
                }

                boardGame.LastUpdated = boardGameDetails.LastUpdated;
                boardGame.Type = RetrieveBoardGameDomainType(boardGameDetails);
                boardGame.Description = boardGameDetails.Description;
                boardGame.ImageUrl = boardGameDetails.ImageUrl;
                boardGame.ThumbnailUrl = boardGameDetails.ThumbnailUrl;
                boardGame.MinNumberOfPlayers = boardGameDetails.MinNumberOfPlayers;
                boardGame.MaxNumberOfPlayers = boardGameDetails.MaxNumberOfPlayers;
                boardGame.MinPlaytimeInMinutes = boardGameDetails.MinPlaytimeInMinutes;
                boardGame.MaxPlaytimeInMinutes = boardGameDetails.MaxPlaytimeInMinutes;
                boardGame.Complexity = boardGameDetails.Complexity;
                boardGame.Rank = boardGameDetails.Rank;
                boardGame.Prices = boardGameDetails.Prices.Select(price => new BoardGameSummaryPriceDto()
                {
                    Region = price.Region,
                    WebsiteUrl = price.WebsiteUrl,
                    LowestPrice = price.Lowest,
                    LowestPriceStoreName = price.LowestStoreName,
                }).ToArray();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Failed to enrich board games with details");
        }
    }

    private async Task CacheBoardGames(IReadOnlyCollection<BoardGameSummaryDto> boardGameSummaries, Dictionary<string, BoardGame> boardGamesDetailsDict)
    {
        var cachedBoardGameIds = boardGamesDetailsDict.Values.Select(boardGame => boardGame.Id);
        var newBoardGameIds = boardGameSummaries.Select(boardGame => boardGame.Id).Except(cachedBoardGameIds);

        _logger.LogInformation($"Adding {newBoardGameIds} to cache.");

        await _cacheService.Add(newBoardGameIds);

        var existingBoardGameIds = cachedBoardGameIds.Except(newBoardGameIds);
        var cacheExpiredBoardGameIds = existingBoardGameIds.Where(existingBoardGameId => boardGamesDetailsDict[existingBoardGameId].LastUpdated == null ||
                                                                                         boardGamesDetailsDict[existingBoardGameId].LastUpdated?.AddMinutes(_cacheService.CacheExpirationInMinutes) <= _dateTimeService.UtcOffsetNow)
                                                           .ToArray();

        _logger.LogInformation($"Updating {cacheExpiredBoardGameIds} in cache.");

        await _cacheService.Update(cacheExpiredBoardGameIds);
    }
}