using BGC.SearchApi.Models.Domain.BoardGameGeek;

namespace BGC.SearchApi.Services.Interfaces;

public interface IBggService
{
    Task<BoardGameSearchResponse> Search(string query, CancellationToken cancellationToken);
}
