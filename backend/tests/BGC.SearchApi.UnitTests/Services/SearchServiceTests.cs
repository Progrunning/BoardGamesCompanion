using BGC.SearchApi.Models.BoardGameGeek;
using BGC.SearchApi.Models.Domain;
using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Repositories.Interfaces;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interfaces;

namespace BGC.SearchApi.UnitTests.Services;

public class SearchServiceTests
{
    private readonly Mock<ILogger<SearchService>> _mockLogger;
    private readonly Mock<IBggService> _mockBggService;
    private readonly Mock<IBoardGamesRepository> _mockBoardGamesRepository;
    private readonly Mock<ICacheService> _mockCacheService;

    private readonly SearchService searchService;

    public SearchServiceTests()
    {
        _mockLogger = new Mock<ILogger<SearchService>>();
        _mockBggService = new Mock<IBggService>();
        _mockBoardGamesRepository = new Mock<IBoardGamesRepository>();
        _mockCacheService = new Mock<ICacheService>();

        searchService = new SearchService(_mockLogger.Object, _mockBggService.Object, _mockBoardGamesRepository.Object, _mockCacheService.Object);
    }

    [Fact]
    public async Task Search_BggFailure_ThrowsBggException()
    {
        var searchQuery = "aisjdiajsida";
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ThrowsAsync(new Exception());

        var searchFunc = async () => await searchService.Search(searchQuery, CancellationToken.None);

        await searchFunc.Should().ThrowAsync<BggException>();
    }

    [Fact]
    public async Task Search_NoBggGamesFound_ReturnsEmptyResults()
    {
        var searchQuery = "aisjdiajsida";
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(new BoardGameSearchResponse());

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        searchResults.Should().BeEmpty();
    }

    [Fact]
    public async Task Search_FindsBggGames_ReturnsGameResults()
    {
        var searchQuery = "Scythe";
        var bggSearchResposne = new BoardGameSearchResponse()
        {
            BoardGames = new List<BoardGameSearchResult>()
            {
                new BoardGameSearchResult("1238", "Scythe", 1987),
                new BoardGameSearchResult("82374", "My Little Scythe", 2018),
            },
        };
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(bggSearchResposne);
        _mockBoardGamesRepository.Setup(repository => repository.GetBoardGames(It.IsAny<IEnumerable<string>>(), It.IsAny<CancellationToken>())).ReturnsAsync(Array.Empty<BoardGame>);

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        searchResults.Should().NotBeEmpty();
        searchResults.Should().HaveCount(bggSearchResposne.BoardGames.Count);
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("1238", "Scythe", 1987));
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("82374", "My Little Scythe", 2018));
    }

    [Fact]
    public async Task Search_EnrichesBoardGameDetails_ReturnsEnrichedGameDetailResults()
    {
        var searchQuery = "Scythe";
        var bggSearchResposne = new BoardGameSearchResponse()
        {
            BoardGames = new List<BoardGameSearchResult>()
            {
                new BoardGameSearchResult("1238", "Scythe", 1987),
                new BoardGameSearchResult("82374", "My Little Scythe", 2018),
            },
        };
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(bggSearchResposne);

        var enrichedBoardGameDetails = new BoardGame()
        {
            Id = "1238",
            ImageUrl = "https://fancy.image.net/funny.jpg",
        };
        _mockBoardGamesRepository.Setup(repository => repository.GetBoardGames(It.IsAny<IEnumerable<string>>(), It.IsAny<CancellationToken>())).ReturnsAsync(new[] { enrichedBoardGameDetails });

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        searchResults.Should().NotBeEmpty();
        searchResults.Should().HaveCount(bggSearchResposne.BoardGames.Count);
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("1238", "Scythe", 1987) { ImageUrl = enrichedBoardGameDetails.ImageUrl });
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("82374", "My Little Scythe", 2018));
    }

    [Fact]
    public async Task Search_NewBoardGames_CachesNewBoardGames()
    {
        var searchQuery = "Scythe";
        var cachedBoardGameId = "1238";
        var newBoardGameId = "82374";
        var bggSearchResposne = new BoardGameSearchResponse()
        {
            BoardGames = new List<BoardGameSearchResult>()
            {
                new BoardGameSearchResult(cachedBoardGameId, "Scythe", 1987),
                new BoardGameSearchResult(newBoardGameId, "My Little Scythe", 2018),
            },
        };
        var cachedBoardGames = new List<BoardGame>()
        {
            new BoardGame()
            {
                Id = cachedBoardGameId,
            },
        };
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(bggSearchResposne);
        _mockBoardGamesRepository.Setup(repository => repository.GetBoardGames(It.IsAny<IEnumerable<string>>(), It.IsAny<CancellationToken>())).ReturnsAsync(cachedBoardGames);

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        _mockCacheService.Verify(service => service.Add(It.Is<IEnumerable<string>>(boardGames => boardGames.Contains(newBoardGameId))), Times.Once);
    }
}