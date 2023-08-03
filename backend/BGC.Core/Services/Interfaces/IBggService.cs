using BGC.Core.Models.BoardGameGeek;

namespace BGC.Core.Services.Interfaces;

public interface IBggService
{
    /// <summary>
    /// Search board games in the BGG collection.
    /// </summary>
    /// <param name="query">Serach query.</param>
    /// <param name="cancellationToken">Cancellation token.</param>
    /// <returns><see cref="BoardGameSearchResponse"/>.</returns>
    Task<BoardGameSearchResponse> Search(string query, CancellationToken cancellationToken);

    /// <summary>
    /// Retrieve board game's details.
    /// </summary>
    /// <param name="boardGameId">Board game id.</param>
    /// <param name="cancellationToken">Cancellation token.</param>
    /// <returns><see cref="BoardGameDetails"/>.</returns>
    Task<BoardGameDetails> GetDetails(string boardGameId, CancellationToken cancellationToken);
}
