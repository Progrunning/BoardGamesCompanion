using BGC.SearchApi.Models.BoardGameGeek;

namespace BGC.SearchApi.Services.Interfaces;

public interface IBggService
{
    Task<BoardGameSearchResponse> Search(string query, CancellationToken cancellationToken);
}
