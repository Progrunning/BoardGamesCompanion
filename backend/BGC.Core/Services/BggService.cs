using System.Xml.Linq;
using System.Xml.Serialization;

using BGC.Core.Models.BoardGameGeek;
using BGC.Core.Models.Dtos;
using BGC.Core.Models.Exceptions;
using BGC.Core.Services.Interfaces;

using Microsoft.Extensions.Logging;

namespace BGC.Core.Services;

/// <summary>
/// BGG API service.
/// </summary>
public class BggService : IBggService
{
    private const string SearchResultsElementName = "items";
    private const string SearchResultBoardGameType = "boardgame";

    private const string SearchResultIdAttributeName = "id";
    private const string SearchResultValueAttributeName = "value";
    private const string SearchResultNameElementName = "name";
    private const string SearchResultYearPublishedElementName = "yearpublished";

    private readonly ILogger<BggService> _logger;
    private readonly HttpClient _httpClient;

    /// <summary>
    /// Initializes a new instance of the <see cref="BggService"/> class.
    /// </summary>
    /// <param name="logger"></param>
    /// <param name="httpClient"></param>
    public BggService(ILogger<BggService> logger, HttpClient httpClient)
    {
        _logger = logger;
        _httpClient = httpClient;
    }

    /// <inheritdoc />
    public async Task<BoardGameSearchResponse> Search(string query, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(query))
        {
            return new BoardGameSearchResponse();
        }

        var requestUri = new Uri($"{_httpClient.BaseAddress}/search?query={query}&type={SearchResultBoardGameType}");
        var searchResponseStream = await _httpClient.GetStreamAsync(requestUri);

        var searchResultsDocument = await XDocument.LoadAsync(searchResponseStream, LoadOptions.None, cancellationToken);
        var searchResultsElement = searchResultsDocument?.Element(SearchResultsElementName);
        if (searchResultsElement is null)
        {
            _logger.LogWarning($"{SearchResultsElementName} not found in the search resuts");
            return new BoardGameSearchResponse();
        }

        var searchResults = new List<BoardGameSearchResult>();

        foreach (XElement searchResult in searchResultsElement.Descendants())
        {
            var boardGameId = searchResult.Attribute(SearchResultIdAttributeName)?.Value;
            var boardGameName = searchResult.Element(SearchResultNameElementName)?.Attribute(SearchResultValueAttributeName)?.Value;
            int.TryParse(searchResult.Element(SearchResultYearPublishedElementName)?.Attribute(SearchResultValueAttributeName)?.Value, out var boardGameYearPublished);

            if (string.IsNullOrEmpty(boardGameId) || string.IsNullOrWhiteSpace(boardGameName))
            {
                continue;
            }

            searchResults.Add(new BoardGameSearchResult(boardGameId, boardGameName, boardGameYearPublished));
        }

        return new BoardGameSearchResponse()
        {
            BoardGames = searchResults,
        };
    }

    /// <inheritdoc />
    public async Task<BoardGameDetails> GetDetails(string boardGameId, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(boardGameId))
        {
            throw new ArgumentNullException(nameof(boardGameId));
        }

        var requestUri = new Uri($"{_httpClient.BaseAddress}/thing?id={boardGameId}");
        var boardGameDetailsResponseStream = await _httpClient.GetStreamAsync(requestUri, cancellationToken);

        var serializer = new XmlSerializer(typeof(BoardGameDetailsResponse));
        var boardGamesDetailsResponse = (BoardGameDetailsResponse?)serializer.Deserialize(boardGameDetailsResponseStream);
        if (!(boardGamesDetailsResponse?.BoardGames?.Any() ?? false))
        {
            throw new XmlParsingException($"Faield to parse xml for {boardGameId}");
        }

        var boardGameDetailsDto = boardGamesDetailsResponse.BoardGames.First();

        return new BoardGameDetails()
        {
            Id = boardGameDetailsDto.Id.ToString(),
        };
    }
}
