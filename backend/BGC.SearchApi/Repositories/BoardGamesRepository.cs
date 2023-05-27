using BGC.SearchApi.Models.Domain;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Repositories.Interfaces;

using Microsoft.Extensions.Options;

using MongoDB.Driver;

namespace BGC.SearchApi.Repositories
{
    public class BoardGamesRepository : IBoardGamesRepository
    {
        private const string BgcDbName = "boardGames";
        private const string BoardGamesDbCollectionName = "bgg";

        private readonly ILogger<BoardGamesRepository> _logger;
        private readonly MongoClient _mongoClient;

        public BoardGamesRepository(ILogger<BoardGamesRepository> logger, IOptions<AppSettings> appSettings)
        {
            _logger = logger;
            _mongoClient = new MongoClient(appSettings.Value.MongoDb!.ConnectionString);
        }

        public async Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds, CancellationToken cancellationToken)
        {
            var boardGamesCollection = _mongoClient.GetDatabase(BgcDbName).GetCollection<BoardGame>(BoardGamesDbCollectionName);

            var projectionBuilder = new ProjectionDefinitionBuilder<BoardGame>();
            var projectionDefinition = projectionBuilder.Include(boardGame => boardGame.ImageUrl);

            var filterBuilder = new FilterDefinitionBuilder<BoardGame>();
            var filter = filterBuilder.In(boardGame => boardGame.Id, boardGameIds);
            //var filterFluent = boardGamesCollection.Find(filter).Project<BoardGame>(projectionDefinition);
            var filterFluent = boardGamesCollection.Find(filter);

            _logger.LogInformation($"Executing the following command in MongoDb: {filterFluent}");

            return await filterFluent.ToListAsync(cancellationToken);
        }
    }
}
