using BGC.Core.Services;
using BGC.Tests.Core.Helpers;

namespace BGC.Core.UnitTests.Services
{
    public class BggServiceTests
    {
        private readonly Uri mockBaseAddress = new Uri("https://whatever");

        private readonly Mock<ILogger<BggService>> _mockLogger;
        private readonly Mock<HttpMessageHandler> _mockMessageHandler;

        private BggService bggService;

        public BggServiceTests()
        {
            _mockLogger = new Mock<ILogger<BggService>>();
            _mockMessageHandler = new Mock<HttpMessageHandler>();

            bggService = new BggService(_mockLogger.Object, new HttpClient(_mockMessageHandler.Object)
            {
                BaseAddress = mockBaseAddress,
            });
        }

        [Fact]
        public async Task Search_EmptyQuery_ReturnsEmptyResponse()
        {
            var searchQuery = string.Empty;

            var searchResponse = await bggService.Search(searchQuery, CancellationToken.None);

            searchResponse.Should().NotBeNull();
            searchResponse.BoardGames.Should().BeEmpty();
        }

        [Fact]
        public async Task Search_HttpFailure_ThrowsException()
        {
            var searchQuery = "Scythe";
            var httpClient = HttpClientHelpers.CreateExceptionThrowingClient(new Exception("Boom!"));
            httpClient.BaseAddress = mockBaseAddress;
            bggService = new BggService(_mockLogger.Object, httpClient);

            var searchFunc = async () => await bggService.Search(searchQuery, CancellationToken.None);

            await searchFunc.Should().ThrowAsync<Exception>();
        }

        // TODO Write tests for the parsing logic (grab BGG response and use as a sample)
    }
}
