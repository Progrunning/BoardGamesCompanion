using System.Xml.Linq;

using BGC.SearchApi.Models.BoardGameGeek;
using BGC.SearchApi.Services.Interfaces;

namespace BGC.SearchApi.Services;

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

    public BggService(ILogger<BggService> logger, HttpClient httpClient)
    {
        _logger = logger;
        _httpClient = httpClient;
    }

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
            BoardGames = searchResults
        };
    }
}
