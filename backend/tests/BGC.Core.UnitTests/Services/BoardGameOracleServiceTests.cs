using BGC.Core.Models.Dtos.BoardGameOracle;
using BGC.Core.Services;
using BGC.Core.Services.Interfaces;
using BGC.Tests.Core.Helpers;

namespace BGC.Core.UnitTests.Services
{
    public class BoardGameOracleServiceTests
    {
        private const string MockBggId = "174430";
        private const RegionDto MockRegion = RegionDto.Australia;

        private const string MockPriceStatsResponse = "{\"region\":\"us\",\"key\":\"bHh_KByEbG\",\"slug\":\"gloomhaven\",\"title\":\"Gloomhaven\",\"bgg_id\":174430,\"url\":\"https://www.boardgameoracle.com/boardgame/price/bHh_KByEbG/gloomhaven\",\"price_stats\":{\"latest\":{\"max\":199.99,\"mean\":143.23833333333334,\"median\":109.49,\"min\":99.99,\"n\":6,\"lowest_store_name\":\"Miniature Market\",\"lowest_store_short_name\":\"Miniature Market\"},\"price_drop_day\":{\"previous_price\":99.99,\"change_percent\":0,\"change_value\":0},\"price_drop_week\":{\"previous_price\":99.99,\"change_percent\":0,\"change_value\":0},\"lowest_30d\":99.99,\"lowest_30d_store\":\"Miniature Market\",\"lowest_30d_date\":\"2023-08-11T00:00:00.000Z\",\"lowest_52w\":82.1,\"lowest_52w_store\":\"Boarding School Games\",\"lowest_52w_date\":\"2022-12-18T00:00:00.000Z\"}}";

        private readonly Uri mockBaseAddress = new Uri("https://whatever");

        private readonly Mock<ILogger<BoardGameOracelService>> _mockLogger;
        private readonly Mock<HttpMessageHandler> _mockMessageHandler;

        private BoardGameOracelService boardGameOracleService;

        public BoardGameOracleServiceTests()
        {
            _mockLogger = new Mock<ILogger<BoardGameOracelService>>();
            _mockMessageHandler = new Mock<HttpMessageHandler>();

            boardGameOracleService = new BoardGameOracelService(_mockLogger.Object, new HttpClient(_mockMessageHandler.Object)
            {
                BaseAddress = mockBaseAddress,
            });
        }

        [Fact]
        public async Task GetPriceStats_InvalidBoardGameId_ReturnsNull()
        {
            var invalidBggId = string.Empty;

            var pricesStatsResponse = await boardGameOracleService.GetPriceStats(invalidBggId, MockRegion, CancellationToken.None);

            pricesStatsResponse.Should().BeNull();
        }

        [Fact]
        public async Task GetPriceStats_RequestFails_ReturnsNull()
        {
            var httpClient = HttpClientHelpers.CreateClientReturningContent(new StringContent(MockPriceStatsResponse));
            httpClient.BaseAddress = mockBaseAddress;
            boardGameOracleService = new BoardGameOracelService(_mockLogger.Object, httpClient);

            var pricesStatsResponse = await boardGameOracleService.GetPriceStats(MockBggId, MockRegion, CancellationToken.None);

            pricesStatsResponse.Should().NotBeNull();
        }
    }
}
