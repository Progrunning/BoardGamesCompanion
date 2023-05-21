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

            var boardGames = await _boardGamesRepository.GetBoardGames(bggSearchResponse.BoardGames.Select(boardGame => boardGame.Id));
            // TODO If detailed info doesn't exists, queue a message to retrieve it

            return bggSearchResponse.BoardGames.Select(boardGame => new BoardGameSummaryDto(boardGame.Id, boardGame.Name, boardGame.YearPublished)).ToArray();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Search failed");

            throw new BggException((int)HttpStatusCode.InternalServerError, "Search failed");
        }
    }
}