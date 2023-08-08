using BGC.Core.Models.Domain;
using BGC.Core.Models.Dtos.BoardGameGeek;
using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.Core.Extensions;

public static class BoardGameDetailsDtoExtensions
{
    public static BoardGame ToDomain(this BoardGameDetailsDto boardGameDetailsDto, IReadOnlyCollection<PriceStatisticsDto>? regionalPriceStatistics)
    {
        return new BoardGame()
        {
            Id = boardGameDetailsDto.Id.ToString(),
            Name = boardGameDetailsDto.PrimaryName,
            Type = boardGameDetailsDto.Type,
            Description = boardGameDetailsDto.Description,
            ThumbnailUrl = boardGameDetailsDto.ThumbnailUrl,
            ImageUrl = boardGameDetailsDto.ImageUrl,
            Complexity = boardGameDetailsDto.Statistics.Ratings.AverageWeight.Value,
            AverageRating = boardGameDetailsDto.Statistics.Ratings.Average.Value,
            MinNumberOfPlayers = boardGameDetailsDto.MinNumberOfPlayers.Value,
            MaxNumberOfPlayers = boardGameDetailsDto.MaxNumberOfPlayers.Value,
            MinPlaytimeInMinutes = boardGameDetailsDto.MinPlaytimeInMinutes.Value,
            MaxPlaytimeInMinutes = boardGameDetailsDto.MaxPlaytimeInMinutes.Value,
            MinAgeInYears = boardGameDetailsDto.MinageInYears.Value,
            PublishedYear = boardGameDetailsDto.YearPublished.Value,
            Rank = boardGameDetailsDto.Rank,
            RankVotes = boardGameDetailsDto.Statistics.Ratings.UsersRate.Value,
            Url = $"{Constants.BggApi.BaseUrl}/boardgame/{boardGameDetailsDto.Id}",
            LastUpdated = DateTimeOffset.UtcNow,

            Artists = boardGameDetailsDto.LinkElements.To(LinkDtoType.Artist),
            Category = boardGameDetailsDto.LinkElements.To(LinkDtoType.Category),
            Designers = boardGameDetailsDto.LinkElements.To(LinkDtoType.Designer),
            Mechanic = boardGameDetailsDto.LinkElements.To(LinkDtoType.Mechanic),
            Publishers = boardGameDetailsDto.LinkElements.To(LinkDtoType.Publisher),
            Expansions = boardGameDetailsDto.LinkElements.To(LinkDtoType.Expansion),

            Prices = regionalPriceStatistics.ToDomain(),
        };
    }
}
