using BGC.SearchApi.Models.Domain;

namespace BGC.SearchApi.Repositories.Interfaces
{
    public interface IBoardGamesRepository
    {
        /// <summary>
        /// Retrieves board game details from the MongoDb
        /// </summary>
        /// <param name="boardGameIds"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds, CancellationToken cancellationToken);
    }
}
