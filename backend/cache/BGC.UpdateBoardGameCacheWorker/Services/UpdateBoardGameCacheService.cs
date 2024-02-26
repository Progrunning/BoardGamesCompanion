using BGC.CacheCore;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services.Interfaces;

namespace BGC.UpdateBoardGameCacheWorker.Services
{
    public class UpdateBoardGameCacheService : BaseUpdateBoardGameCacheService<UpdateBoardGameCacheService>
    {
        public UpdateBoardGameCacheService(
            ILogger<UpdateBoardGameCacheService> logger,
            IBggService bggService,
            IBoardGamesRepository boardGamesRepository,
            IBoardGameOracleService boardGameOracleService)
            : base(logger, bggService, boardGamesRepository, boardGameOracleService)
        {
        }
    }
}
