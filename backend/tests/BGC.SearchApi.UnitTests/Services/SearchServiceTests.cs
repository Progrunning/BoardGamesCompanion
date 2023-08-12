using BGC.Core.Extensions;
using BGC.Core.Models.Domain;
using BGC.Core.Models.Dtos.BoardGameGeek;
using BGC.Core.Models.Dtos.BoardGameOracle;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services.Interfaces;
using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
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
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(new BoardGameSearchResponseDto());

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        searchResults.Should().BeEmpty();
    }

    [Fact]
    public async Task Search_FindsBggGames_ReturnsGameResults()
    {
        var searchQuery = "Scythe";
        var bggSearchResposne = new BoardGameSearchResponseDto()
        {
            BoardGames = new[]
            {
                new BoardGameSearchItemDto()
                {
                    Id = 1238,
                    Name = new BoardGameSearchItemNameDto() { Value = "Scythe" },
                    YearPublished = new YearPublishedDto() { Value = 1987 },
                },
                new BoardGameSearchItemDto()
                {
                    Id = 82374,
                    Name = new BoardGameSearchItemNameDto() { Value = "My Little Scythe" },
                    YearPublished = new YearPublishedDto() { Value = 2018 },
                },
            },
        };
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(bggSearchResposne);
        _mockBoardGamesRepository.Setup(repository => repository.GetBoardGames(It.IsAny<IEnumerable<string>>(), It.IsAny<CancellationToken>())).ReturnsAsync(Array.Empty<BoardGame>);

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        searchResults.Should().NotBeEmpty();
        searchResults.Should().HaveCount(bggSearchResposne.BoardGames.Length);
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("1238", "Scythe", 1987));
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("82374", "My Little Scythe", 2018));
    }

    [Fact]
    public async Task Search_EnrichesBoardGameDetails_ReturnsEnrichedGameDetailResults()
    {
        var searchQuery = "Scythe";
        var bggSearchResposne = new BoardGameSearchResponseDto()
        {
            BoardGames = new[]
            {
                new BoardGameSearchItemDto()
                {
                    Id = 1238,
                    Name = new BoardGameSearchItemNameDto() { Value = "Scythe" },
                    YearPublished = new YearPublishedDto() { Value = 1987 },
                },
                new BoardGameSearchItemDto()
                {
                    Id = 82374,
                    Name = new BoardGameSearchItemNameDto() { Value = "My Little Scythe" },
                    YearPublished = new YearPublishedDto() { Value = 2018 },
                },
            },
        };
        _mockBggService.Setup(service => service.Search(searchQuery, It.IsAny<CancellationToken>())).ReturnsAsync(bggSearchResposne);

        var enrichedBoardGameDetails = new BoardGame()
        {
            Id = "1238",
            ImageUrl = "https://fancy.image.net/funny.jpg",
            Prices = new[]
            {
                new Prices()
                {
                    Region = RegionDto.Australia.ToAbbreviation()!,
                    WebsiteUrl = "https://nothingtoseehere.com",
                    Lowest = 12.31,
                    LowestStoreName = "Amazon",
                },
            },
        };
        _mockBoardGamesRepository.Setup(repository => repository.GetBoardGames(It.IsAny<IEnumerable<string>>(), It.IsAny<CancellationToken>())).ReturnsAsync(new[] { enrichedBoardGameDetails });

        var searchResults = await searchService.Search(searchQuery, CancellationToken.None);
        searchResults.Should().NotBeEmpty();
        searchResults.Should().HaveCount(bggSearchResposne.BoardGames.Length);
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("1238", "Scythe", 1987)
        {
            ImageUrl = enrichedBoardGameDetails.ImageUrl,
            Prices = new BoardGameSummaryPriceDto[]
            {
                new BoardGameSummaryPriceDto()
                {
                    Region = enrichedBoardGameDetails.Prices.First().Region,
                    WebsiteUrl = enrichedBoardGameDetails.Prices.First().WebsiteUrl,
                    LowestPrice = enrichedBoardGameDetails.Prices.First().Lowest,
                    LowestPriceStoreName = enrichedBoardGameDetails.Prices.First().LowestStoreName,
                },
            },
        });
        searchResults.Should().ContainEquivalentOf(new BoardGameSummaryDto("82374", "My Little Scythe", 2018));
    }

    [Fact]
    public async Task Search_NewBoardGames_CachesNewBoardGames()
    {
        var searchQuery = "Scythe";
        var cachedBoardGameId = "1238";
        var newBoardGameId = "82374";
        var bggSearchResposne = new BoardGameSearchResponseDto()
        {
            BoardGames = new[]
            {
                new BoardGameSearchItemDto()
                {
                    Id = 1238,
                    Name = new BoardGameSearchItemNameDto() { Value = "Scythe" },
                    YearPublished = new YearPublishedDto() { Value = 1987 },
                },
                new BoardGameSearchItemDto()
                {
                    Id = 82374,
                    Name = new BoardGameSearchItemNameDto() { Value = "My Little Scythe" },
                    YearPublished = new YearPublishedDto() { Value = 2018 },
                },
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