using BGC.SearchApi.Models.Domain;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Repositories.Interfaces;

using Microsoft.Extensions.Options;

using MongoDB.Driver;

namespace BGC.SearchApi.Repositories
{
    public class BoardGamesRepository : IBoardGamesRepository
    {
        private const string BgcDbName = "boardGamesCompanion";
        private const string BoardGamesDbCollectionName = "boardGames";

        private readonly ILogger<BoardGamesRepository> _logger;
        private readonly MongoClient _mongoClient;

        public BoardGamesRepository(ILogger<BoardGamesRepository> logger, IOptions<AppSettings> appSettings)
        {
            _logger = logger;
            _mongoClient = new MongoClient(appSettings.Value.MongoDb!.ConnectionString);
        }

        public async Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds)
        {
            var boardGamesCollection = _mongoClient.GetDatabase(BgcDbName).GetCollection<BoardGame>(BoardGamesDbCollectionName);
            var filterBuilder = new FilterDefinitionBuilder<BoardGame>();
            var filter = filterBuilder.In(boardGame => boardGame.Id, boardGameIds);

            return await boardGamesCollection.Find(filter).ToListAsync();
        }
    }
}
