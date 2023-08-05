using BGC.Core.Models.Domain;
using BGC.Core.Repositories.Interfaces;

using Microsoft.Extensions.Logging;

using MongoDB.Driver;

namespace BGC.Core.Repositories
{
    /// <inheritdoc />
    public class BoardGamesRepository : IBoardGamesRepository
    {
        private readonly ILogger<BoardGamesRepository> _logger;
        private readonly IMongoCollection<BoardGame> _boardGamesCollection;

        /// <summary>
        /// Initializes a new instance of the <see cref="BoardGamesRepository"/> class.
        /// </summary>
        /// <param name="logger"></param>
        /// <param name="mongoClient"></param>
        public BoardGamesRepository(ILogger<BoardGamesRepository> logger, IMongoClient mongoClient)
        {
            _logger = logger;
            _boardGamesCollection = mongoClient.GetDatabase(Constants.MongoDb.BgcDbName).GetCollection<BoardGame>(Constants.MongoDb.BoardGamesDbCollectionName);
        }

        /// <inheritdoc />
        public IMongoCollection<BoardGame> BoardGamesCollection => _boardGamesCollection;

        /// <inheritdoc />
        public async Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds, CancellationToken cancellationToken)
        {
            var filterBuilder = new FilterDefinitionBuilder<BoardGame>();
            var filter = filterBuilder.In(boardGame => boardGame.Id, boardGameIds);
            var filterFluent = BoardGamesCollection.Find(filter);

            return await filterFluent.ToListAsync(cancellationToken);
        }
    }
}
