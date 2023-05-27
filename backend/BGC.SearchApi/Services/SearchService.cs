using System.Net;

using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Repositories.Interfaces;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

namespace BGC.SearchApi.Services;

public class SearchService : ISearchService
{
    private readonly ILogger<SearchService> _logger;
    private readonly IBggService _bggService;
    private readonly IBoardGamesRepository _boardGamesRepository;

    public SearchService(ILogger<SearchService> logger, IBggService bggService, IBoardGamesRepository boardGamesRepository)
    {
        _logger = logger;
        _bggService = bggService;
        _boardGamesRepository = boardGamesRepository;
    }

    public async Task<IReadOnlyCollection<BoardGameSummaryDto>> Search(string query, CancellationToken cancellationToken)
    {
        try
        {
            var bggSearchResponse = await _bggService.Search(query, cancellationToken);
            if (bggSearchResponse.IsEmpty)
            {
                return Array.Empty<BoardGameSummaryDto>();
            }

            // TODO If detailed info doesn't exists, queue a message to retrieve it

            var boardGames = bggSearchResponse.BoardGames.Select(boardGame => new BoardGameSummaryDto(boardGame.Id, boardGame.Name, boardGame.YearPublished)).ToArray();
            await EnrichBoardGameDetails(boardGames, cancellationToken);

            return boardGames;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Search failed");

            throw new BggException((int)HttpStatusCode.InternalServerError, "Search failed");
        }
    }

    private async Task EnrichBoardGameDetails(IReadOnlyCollection<BoardGameSummaryDto> boardGames, CancellationToken cancellationToken)
    {
        try
        {
            var boardGamesDetails = await _boardGamesRepository.GetBoardGames(boardGames.Select(boardGame => boardGame.Id), cancellationToken);
            var boardGamesDetailsDict = boardGamesDetails.ToDictionary(boardGame => boardGame.Id);
            foreach (var boardGame in boardGames)
            {
                if (!boardGamesDetailsDict.TryGetValue(boardGame.Id, out var boardGameDetails))
                {
                    continue;
                }

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
}