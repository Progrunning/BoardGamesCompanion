using BGC.Core.Models.Domain;

using MongoDB.Driver;

namespace BGC.Core.Repositories.Interfaces
{
    /// <summary>
    /// Board games repository.
    /// </summary>
    public interface IBoardGamesRepository
    {
        /// <summary>
        /// Gets mongo's board games collection.
        /// </summary>
        IMongoCollection<BoardGame> BoardGamesCollection { get; }

        /// <summary>
        /// Retrieves board game details from the MongoDb
        /// </summary>
        /// <param name="boardGameIds"></param>
        /// <param name="cancellationToken"></param>
        /// <returns>Collection of <see cref="BoardGame"/>.</returns>
        Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds, CancellationToken cancellationToken);

        /// <summary>
        /// Updates board game in MongoDb.
        /// </summary>
        /// <param name="boardGame"></param>
        /// <returns></returns>
        Task UpsertBoardGame(BoardGame boardGame, CancellationToken cancellationToken);
    }
}
