using System.Text.Json;

using AutoFixture;

using Azure.Messaging.ServiceBus;

using BGC.Core.Models.Domain;
using BGC.Core.Models.Dtos.BoardGameGeek;
using BGC.Core.Models.Dtos.BoardGameOracle;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services.Interfaces;
using BGC.Functions.Functions;
using BGC.Functions.Models;
using BGC.Tests.Core.Extensions;

namespace BGC.Functions.UnitTests.Functions
{
    public class UpdateBoardGameCacheFunctionTests
    {
        private readonly Fixture fixture = new Fixture();

        private readonly Mock<ILogger<UpdateBoardGameCacheFunction>> _mockLogger;
        private readonly Mock<IBggService> _mockBggService;
        private readonly Mock<IBoardGamesRepository> _mockBoardGamesRepository;
        private readonly Mock<IBoardGameOracleService> _mockBoardGameOracleService;

        private readonly UpdateBoardGameCacheFunction _updateBoardGameCacheFunction;

        public UpdateBoardGameCacheFunctionTests()
        {
            _mockLogger = new Mock<ILogger<UpdateBoardGameCacheFunction>>();
            _mockBggService = new Mock<IBggService>();
            _mockBoardGamesRepository = new Mock<IBoardGamesRepository>();
            _mockBoardGameOracleService = new Mock<IBoardGameOracleService>();

            _updateBoardGameCacheFunction = new UpdateBoardGameCacheFunction(
                _mockLogger.Object,
                _mockBggService.Object,
                _mockBoardGamesRepository.Object,
                _mockBoardGameOracleService.Object);
        }

        [Fact]
        public async Task ExecuteFunction_Emptymessage_ThrowsJsonException()
        {
            var mockMessage = ServiceBusModelFactory.ServiceBusReceivedMessage();

            var runFunc = async () => await _updateBoardGameCacheFunction.Run(mockMessage);

            await runFunc.Should().ThrowAsync<JsonException>();
        }

        [Fact]
        public async Task ExecuteFunction_GameDetailsRetrievalFailure_ThrowsException()
        {
            var mockBoardGameId = 123124;
            var mockMessageData = new CacheBoardGameMessage()
            {
                BoardGameId = mockBoardGameId.ToString(),
            };
            var mockMessage = ServiceBusModelFactory.ServiceBusReceivedMessage(new BinaryData(mockMessageData.ToByteArray()));
            _mockBggService.Setup(service => service.GetDetails(mockBoardGameId.ToString(), It.IsAny<CancellationToken>())).ThrowsAsync(new HttpRequestException());

            var runFunc = async () => await _updateBoardGameCacheFunction.Run(mockMessage);

            await runFunc.Should().ThrowAsync<HttpRequestException>();
        }

        [Fact]
        public async Task ExecuteFunction_UpdateBoardGameCache_Success()
        {
            var mockBoardGameDetails = fixture.Create<BoardGameDetailsDto>();
            var mockMessageData = fixture.Build<CacheBoardGameMessage>()
                                         .With(message => message.BoardGameId, mockBoardGameDetails.Id.ToString())
                                         .Create();
            var mockMessage = ServiceBusModelFactory.ServiceBusReceivedMessage(new BinaryData(mockMessageData.ToByteArray()));

            _mockBggService.Setup(service => service.GetDetails(mockMessageData.BoardGameId, It.IsAny<CancellationToken>()))
                           .ReturnsAsync(() => mockBoardGameDetails);

            await _updateBoardGameCacheFunction.Run(mockMessage);

            foreach (RegionDto regionDto in Enum.GetValues(typeof(RegionDto)))
            {
                _mockBoardGameOracleService.Verify(service => service.GetPriceStats(mockMessageData.BoardGameId, regionDto, It.IsAny<CancellationToken>()), Times.Once);
            }

            _mockBoardGamesRepository.Verify(repository => repository.UpsertBoardGame(It.IsAny<BoardGame>(), It.IsAny<CancellationToken>()));
        }

        [Fact]
        public async Task ExecuteFunction_PriceStatsRetrievalFailure_CacheUpdateSuccess()
        {
            var mockBoardGameDetails = fixture.Create<BoardGameDetailsDto>();
            var mockMessageData = fixture.Build<CacheBoardGameMessage>()
                                         .With(message => message.BoardGameId, mockBoardGameDetails.Id.ToString())
                                         .Create();
            var mockMessage = ServiceBusModelFactory.ServiceBusReceivedMessage(new BinaryData(mockMessageData.ToByteArray()));

            _mockBoardGameOracleService.Setup(service => service.GetPriceStats(mockMessageData.BoardGameId, It.IsAny<RegionDto>(), It.IsAny<CancellationToken>())).ReturnsAsync(() => null);
            _mockBggService.Setup(service => service.GetDetails(mockMessageData.BoardGameId, It.IsAny<CancellationToken>()))
                           .ReturnsAsync(() => mockBoardGameDetails);

            await _updateBoardGameCacheFunction.Run(mockMessage);

            _mockBoardGamesRepository.Verify(repository => repository.UpsertBoardGame(It.IsAny<BoardGame>(), It.IsAny<CancellationToken>()));
        }
    }
}
