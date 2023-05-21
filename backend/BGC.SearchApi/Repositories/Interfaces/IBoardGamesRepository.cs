using BGC.SearchApi.Models.Domain;

namespace BGC.SearchApi.Repositories.Interfaces
{
    public interface IBoardGamesRepository
    {
        Task<IReadOnlyCollection<BoardGame>> GetBoardGames(IEnumerable<string> boardGameIds);
    }
}
