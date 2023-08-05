using System.Collections.Generic;
using System.Net;

using BGC.Core.Models.Domain;
using BGC.Core.Services.Interfaces;
using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Repositories.Interfaces;
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

    /// <summary>
    /// Initializes a new instance of the <see cref="SearchService"/> class.
    /// </summary>
    /// <param name="logger"></param>
    /// <param name="bggService"></param>
    /// <param name="boardGamesRepository"></param>
    /// <param name="cacheService"></param>
    public SearchService(ILogger<SearchService> logger, IBggService bggService, IBoardGamesRepository boardGamesRepository, ICacheService cacheService)
    {
        _logger = logger;
        _bggService = bggService;
        _boardGamesRepository = boardGamesRepository;
        _cacheService = cacheService;
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

            var boardGameSummaries = bggSearchResponse.BoardGames.Select(boardGame => new BoardGameSummaryDto(boardGame.Id, boardGame.Name, boardGame.YearPublished)).ToArray();

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

                boardGame.Type = boardGameDetails.Type;
                boardGame.Description = boardGameDetails.Description;
                boardGame.ImageUrl = boardGameDetails.ImageUrl;
                boardGame.ThumbnailUrl = boardGameDetails.ThumbnailUrl;
                boardGame.MinNumberOfPlayers = boardGameDetails.MinNumberOfPlayers;
                boardGame.MaxNumberOfPlayers = boardGameDetails.MaxNumberOfPlayers;
                boardGame.MinPlaytimeInMinutes = boardGameDetails.MinPlaytimeInMinutes;
                boardGame.MaxPlaytimeInMinutes = boardGameDetails.MaxPlaytimeInMinutes;
                boardGame.Complexity = boardGameDetails.Complexity;
                boardGame.Rank = boardGameDetails.Rank;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Failed to enrich board games with details");
        }
    }

    private async Task CacheBoardGames(IReadOnlyCollection<BoardGameSummaryDto> boardGameSummaries, Dictionary<string, BoardGame> boardGamesDetailsDict)
    {
        var newBoardGameIds = boardGameSummaries.Select(boardGame => boardGame.Id).Except(boardGamesDetailsDict.Values.Select(boardGame => boardGame.Id));
        await _cacheService.Add(newBoardGameIds);

        // TODO Handle expired board game details
    }
}