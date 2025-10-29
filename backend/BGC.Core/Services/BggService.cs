using System.Xml.Serialization;

using BGC.Core.Models.Dtos.BoardGameGeek;
using BGC.Core.Models.Exceptions;
using BGC.Core.Services.Interfaces;

using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;

namespace BGC.Core.Services;

/// <summary>
/// BGG API service.
/// </summary>
public class BggService : IBggService
{
    private const string SearchQueryCacheKeyFormat = "bgg_search_{0}";
    private const int SearchQueryCacheLifetimeInMinutes = 60;

    private const string SearchResultBoardGameType = "boardgame";

    private readonly ILogger<BggService> _logger;
    private readonly HttpClient _httpClient;
    private readonly IMemoryCache _memoryCache;

    /// <summary>
    /// Initializes a new instance of the <see cref="BggService"/> class.
    /// </summary>
    /// <param name="logger"></param>
    /// <param name="httpClient"></param>
    public BggService(ILogger<BggService> logger, HttpClient httpClient, IMemoryCache memoryCache)
    {
        _logger = logger;
        _httpClient = httpClient;
        _memoryCache = memoryCache;
    }

    /// <inheritdoc />
    public async Task<BoardGameSearchResponseDto> Search(string query, CancellationToken cancellationToken)
    {
        query = SanitizeQuery(query);
        if (string.IsNullOrWhiteSpace(query))
        {
            return new BoardGameSearchResponseDto();
        }

        if (_memoryCache.TryGetValue(CreateCacheKey(query), out BoardGameSearchResponseDto? cachedResult) && cachedResult is not null)
        {
            _logger.LogDebug("Cache hit for BGG search with query {Query}", query);
            return cachedResult;
        }

        var requestUri = new Uri($"{_httpClient.BaseAddress}/search?query={query}&type={SearchResultBoardGameType}");
        using var searchResponseStream = await _httpClient.GetStreamAsync(requestUri, cancellationToken);

        using var searchResponseMemoryStream = new MemoryStream();
        await searchResponseStream.CopyToAsync(searchResponseMemoryStream, cancellationToken);
        searchResponseMemoryStream.Position = 0;

        using var reader = new StreamReader(searchResponseMemoryStream);
        var searchResponseString = await reader.ReadToEndAsync();
        _logger.LogDebug(searchResponseString);

        searchResponseMemoryStream.Position = 0;

        var serializer = new XmlSerializer(typeof(BoardGameSearchResponseDto));
        var boardGamesDetailsResponse = (BoardGameSearchResponseDto?)serializer.Deserialize(searchResponseMemoryStream);
        if (boardGamesDetailsResponse is null)
        {
            throw new XmlParsingException($"Faield to parse search results for query {query}");
        }

        _memoryCache.Set(CreateCacheKey(query), boardGamesDetailsResponse, TimeSpan.FromMinutes(SearchQueryCacheLifetimeInMinutes));

        return boardGamesDetailsResponse;
    }

    /// <inheritdoc />
    public async Task<BoardGameDetailsDto> GetDetails(string boardGameId, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(boardGameId))
        {
            throw new ArgumentNullException(nameof(boardGameId));
        }

        var requestUri = new Uri($"{_httpClient.BaseAddress}/thing?id={boardGameId}&stats=1");
        var boardGameDetailsResponseStream = await _httpClient.GetStreamAsync(requestUri, cancellationToken);

        var serializer = new XmlSerializer(typeof(BoardGameDetailsResponseDto));
        var boardGamesDetailsResponse = (BoardGameDetailsResponseDto?)serializer.Deserialize(boardGameDetailsResponseStream);
        if (!(boardGamesDetailsResponse?.BoardGames?.Any() ?? false))
        {
            throw new XmlParsingException($"Faield to parse xml for {boardGameId}");
        }

        return boardGamesDetailsResponse.BoardGames.First();
    }

    private static string CreateCacheKey(string query)
    {
        return string.Format(SearchQueryCacheKeyFormat, SanitizeQuery(query));
    }

    private static string SanitizeQuery(string query)
    {
        return query.Trim().ToLowerInvariant();
    }
}
