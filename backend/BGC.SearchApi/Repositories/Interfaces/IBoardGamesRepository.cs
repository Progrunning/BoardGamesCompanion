using BGC.Core.Models.Domain;

using MongoDB.Driver;

namespace BGC.SearchApi.Repositories.Interfaces
{
    public interface IBoardGamesRepository
    {
        /// <summary>
        /// Mongo's board games collection.
        /// </summary>
        IMongoCollection<BoardGame> BoardGamesCollection { get; }

        /// <summary>
        /// Retrieves board game details from the MongoDb
        /// </summary>
        /// <param name="boardGameIds"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds, CancellationToken cancellationToken);
    }
}
