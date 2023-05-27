namespace BGC.SearchApi.Models.Dtos;

public class BoardGameSummaryDto
{
    public BoardGameSummaryDto(string id, string name, int yearPublished)
    {
        Id = id;
        Name = name;
        YearPublished = yearPublished;
    }

    public string Id { get; init; }

    public string Name { get; init; }

    public int YearPublished { get; init; }

    public string? ImageUrl { get; set; }

    public string? ThumbnailUrl { get; set; }

    public string? Description { get; set; }

    public int? MinNumberOfPlayers { get; set; }

    public int? MaxNumberOfPlayers { get; set; }

    public int? MinPlaytimeInMinutes { get; set; }

    public int? MaxPlaytimeInMinutes { get; set; }

    public double? Complexity { get; set; }

    public int? Rank { get; set; }
}
