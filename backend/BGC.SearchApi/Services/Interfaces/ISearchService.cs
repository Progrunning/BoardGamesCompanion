using BGC.SearchApi.Models.Dtos;

namespace BGC.SearchApi.Services.Interface;

/// <summary>
/// Search service interface.
/// </summary>
public interface ISearchService
{
    /// <summary>
    /// Search board games with a <see cref="query"/>.
    /// </summary>
    /// <param name="query"></param>
    /// <param name="cancellationToken"></param>
    /// <returns>A collection of <see cref="BoardGameSummaryDto"/>.</returns>
    Task<IReadOnlyCollection<BoardGameSummaryDto>> Search(string query, CancellationToken cancellationToken);
}