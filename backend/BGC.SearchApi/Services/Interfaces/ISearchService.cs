using BGC.SearchApi.Models.Dtos;

namespace BGC.SearchApi.Services.Interface;

public interface ISearchService
{
    Task<IReadOnlyCollection<BoardGameSummaryDto>> Search(string query);
}