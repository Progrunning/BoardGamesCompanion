using BGC.Core.Models.Domain;
using BGC.SearchApi.Common;
using BGC.SearchApi.Repositories.Interfaces;

using MongoDB.Driver;

namespace BGC.SearchApi.Repositories
{
    public class BoardGamesRepository : IBoardGamesRepository
    {
        private readonly ILogger<BoardGamesRepository> _logger;
        private readonly IMongoCollection<BoardGame> _boardGamesCollection;

        public BoardGamesRepository(ILogger<BoardGamesRepository> logger, IMongoClient mongoClient)
        {
            _logger = logger;
            _boardGamesCollection = mongoClient.GetDatabase(Constants.MongoDb.BgcDbName).GetCollection<BoardGame>(Constants.MongoDb.BoardGamesDbCollectionName);
        }

        public IMongoCollection<BoardGame> BoardGamesCollection => _boardGamesCollection;

        public async Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds, CancellationToken cancellationToken)
        {
            var filterBuilder = new FilterDefinitionBuilder<BoardGame>();
            var filter = filterBuilder.In(boardGame => boardGame.Id, boardGameIds);
            var filterFluent = BoardGamesCollection.Find(filter);

            return await filterFluent.ToListAsync(cancellationToken);
        }
    }
}
