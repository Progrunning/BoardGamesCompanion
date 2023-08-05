using BGC.Core.Models.Domain;
using BGC.Core.Repositories;
using BGC.SearchApi.Common;

using MongoDB.Driver;

namespace BGC.SearchApi.UnitTests.Repositories
{
    public class BoardGamesRepositoryTests
    {
        private readonly Mock<ILogger<BoardGamesRepository>> _mockLogger;

        private Mock<IAsyncCursor<BoardGame>> _mockBoardGameCursor = null!;
        private Mock<IMongoCollection<BoardGame>> _mockMongoCollection = null!;
        private Mock<IMongoDatabase> _mockMongoDb = null!;
        private Mock<IMongoClient> _mockMongoClient = null!;

        private BoardGamesRepository _boardGamesRepository = null!;

        public BoardGamesRepositoryTests()
        {
            _mockLogger = new Mock<ILogger<BoardGamesRepository>>();
        }

        [Fact]
        public async Task GetBoardGames_FindNothing_ReturnsEmptyCollection()
        {
            CreateBoardGamesRepository(Array.Empty<BoardGame>());

            var boardGames = await _boardGamesRepository.GetBoardGames(new[] { "1239 " }, CancellationToken.None);

            boardGames.Should().NotBeNull();
            boardGames.Should().BeEmpty();
        }

        [Fact]
        public async Task GetBoardGames_FindsBoardGames_ReturnsGamesCollection()
        {
            var firstGameId = "10290";
            var secondGameId = "9784753";
            var boardGames = new[]
            {
                new BoardGame()
                {
                    Id = firstGameId
                },
                new BoardGame()
                {
                    Id = secondGameId
                },
            };
            CreateBoardGamesRepository(boardGames);

            var foundBoardGames = await _boardGamesRepository.GetBoardGames(new[] { firstGameId, secondGameId }, CancellationToken.None);

            foundBoardGames.Should().NotBeEmpty();
            foundBoardGames.Should().BeEquivalentTo(boardGames);
        }

        private void CreateBoardGamesRepository(IReadOnlyCollection<BoardGame> boardGames)
        {
            _mockBoardGameCursor = new Mock<IAsyncCursor<BoardGame>>();
            _mockBoardGameCursor.Setup(cursor => cursor.Current).Returns(boardGames);
            _mockBoardGameCursor.SetupSequence(cursor => cursor.MoveNext(It.IsAny<CancellationToken>())).Returns(true).Returns(false);
            _mockBoardGameCursor.SetupSequence(cursor => cursor.MoveNextAsync(It.IsAny<CancellationToken>())).Returns(Task.FromResult(true)).Returns(Task.FromResult(false));
            _mockMongoCollection = new Mock<IMongoCollection<BoardGame>>();
            _mockMongoCollection.Setup(collection => collection.FindAsync(It.IsAny<FilterDefinition<BoardGame>>(), It.IsAny<FindOptions<BoardGame>>(), It.IsAny<CancellationToken>())).ReturnsAsync(_mockBoardGameCursor.Object);
            _mockMongoDb = new Mock<IMongoDatabase>();
            _mockMongoDb.Setup(settings => settings.GetCollection<BoardGame>(Constants.MongoDb.BoardGamesDbCollectionName, default)).Returns(_mockMongoCollection.Object);
            _mockMongoClient = new Mock<IMongoClient>();
            _mockMongoClient.Setup(settings => settings.GetDatabase(Constants.MongoDb.BgcDbName, default)).Returns(_mockMongoDb.Object);

            _boardGamesRepository = new BoardGamesRepository(_mockLogger.Object, _mockMongoClient.Object);
        }
    }
}
