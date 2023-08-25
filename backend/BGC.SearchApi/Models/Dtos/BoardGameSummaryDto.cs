namespace BGC.SearchApi.Models.Dtos;

public record BoardGameSummaryDto
{
    /// <summary>
    /// Initializes a new instance of the <see cref="BoardGameSummaryDto"/> class.
    /// </summary>
    /// <param name="id"></param>
    /// <param name="name"></param>
    /// <param name="yearPublished"></param>
    /// <remarks>Model is based on the data returned from the BGG XML API.</remarks>
    public BoardGameSummaryDto(string id, string name, int yearPublished)
    {
        Id = id;
        Name = name;
        YearPublished = yearPublished;
    }

    public string Id { get; init; }

    public string Name { get; init; }

    public int YearPublished { get; init; }

    /// <summary>
    /// Gets or sets type of the board game (e.g. BoardGame or BoardGameExpansion).
    /// </summary>
    public string Type { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public string? ThumbnailUrl { get; set; }

    public string? Description { get; set; }

    public int? MinNumberOfPlayers { get; set; }

    public int? MaxNumberOfPlayers { get; set; }

    public int? MinPlaytimeInMinutes { get; set; }

    public int? MaxPlaytimeInMinutes { get; set; }

    public double? Complexity { get; set; }

    public int? Rank { get; set; }

    /// <summary>
    /// Gets or sets the date of when the game was last updated.
    /// </summary>
    public DateTimeOffset? LastUpdated { get; set; }

    /// <summary>
    /// Gets or sets game prices.
    /// </summary>
    public IReadOnlyCollection<BoardGameSummaryPriceDto> Prices { get; set; } = Array.Empty<BoardGameSummaryPriceDto>();
}
