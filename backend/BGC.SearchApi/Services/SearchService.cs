using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Services.Interface;

namespace BGC.SearchApi.Services;

public class SearchService : ISearchService
{
    public async Task<IReadOnlyCollection<BoardGameSummaryDto>> Search(string query)
    {
        return new[] { new BoardGameSummaryDto("Scythe") };
    }
}