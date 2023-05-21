namespace BGC.SearchApi.Models.BoardGameGeek;

public record BoardGameSearchResponse
{
    public IReadOnlyCollection<BoardGameSearchResult> BoardGames { get; init; } = Array.Empty<BoardGameSearchResult>();

    public bool IsEmpty => !BoardGames.Any();
}

public record BoardGameSearchResult(string Id, string Name, int YearPublished);