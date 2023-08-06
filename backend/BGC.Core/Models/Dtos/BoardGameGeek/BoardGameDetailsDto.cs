using System.Xml.Serialization;

using DnsClient;

namespace BGC.Core.Models.Dtos.BoardGameGeek;

[XmlRoot(ElementName = "item")]
public record BoardGameDetailsDto
{
    [XmlAttribute(AttributeName = "id")]
    public int Id { get; init; }

    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlElement(ElementName = "name")]
    public List<BoardGameNameDto> NameElements { get; init; }

    [XmlIgnore]
    public string PrimaryName => NameElements.FirstOrDefault(n => n.Type == "primary")?.Name ?? NameElements.First().Name;

    [XmlElement(ElementName = "thumbnail")]
    public string ThumbnailUrl { get; init; }

    [XmlElement(ElementName = "image")]
    public string ImageUrl { get; init; }

    [XmlElement(ElementName = "description")]
    public string Description { get; init; }

    [XmlElement(ElementName = "yearpublished")]
    public YearPublishedDto YearPublished { get; init; }

    [XmlElement(ElementName = "minplayers")]
    public MinNumberOfPlayersDto MinNumberOfPlayers { get; init; }

    [XmlElement(ElementName = "maxplayers")]
    public MaxNumberOfPlayersDto MaxNumberOfPlayers { get; init; }

    [XmlElement(ElementName = "poll")]
    public List<Poll> Poll { get; init; }

    [XmlElement(ElementName = "playingtime")]
    public PlayingTimeDto Playingtime { get; init; }

    [XmlElement(ElementName = "minplaytime")]
    public MinPlaytimeDto MinPlaytimeInMinutes { get; init; }

    [XmlElement(ElementName = "maxplaytime")]
    public MaxPlaytimeDto MaxPlaytimeInMinutes { get; init; }

    [XmlElement(ElementName = "minage")]
    public MinAgeDto MinageInYears { get; init; }

    [XmlElement(ElementName = "link")]
    public List<LinkDto> LinkElements { get; init; }

    [XmlElement(ElementName = "statistics")]
    public StatisticsDto Statistics { get; set; }

    [XmlIgnore]
    public int? Rank
    {
        get
        {
            var boardGameRanking = Statistics.Ratings.GameRankings.Rankings.FirstOrDefault(r => r.Name == "boardgame");
            if (int.TryParse(boardGameRanking?.Value, out var rank))
            {
                return rank;
            }

            return null;
        }
    }
}

[XmlRoot(ElementName = "name")]
public record BoardGameNameDto
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "sortindex")]
    public int SortIndex { get; init; }

    [XmlAttribute(AttributeName = "value")]
    public string Name { get; init; }
}

[XmlRoot(ElementName = "minplayers")]
public record MinNumberOfPlayersDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "maxplayers")]
public record MaxNumberOfPlayersDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "result")]
public record Result
{
    [XmlAttribute(AttributeName = "value")]
    public string Value { get; init; }

    [XmlAttribute(AttributeName = "numvotes")]
    public int Numvotes { get; init; }

    [XmlAttribute(AttributeName = "level")]
    public int Level { get; init; }
}

[XmlRoot(ElementName = "results")]
public record Results
{
    [XmlElement(ElementName = "result")]
    public List<Result> Result { get; init; }

    [XmlAttribute(AttributeName = "numplayers")]
    public string Numplayers { get; init; }
}

[XmlRoot(ElementName = "poll")]
public record Poll
{
    [XmlElement(ElementName = "results")]
    public List<Results> Results { get; init; }

    [XmlAttribute(AttributeName = "name")]
    public string Name { get; init; }

    [XmlAttribute(AttributeName = "title")]
    public string Title { get; init; }

    [XmlAttribute(AttributeName = "totalvotes")]
    public int Totalvotes { get; init; }
}

[XmlRoot(ElementName = "playingtime")]
public record PlayingTimeDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "minplaytime")]
public record MinPlaytimeDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "maxplaytime")]
public record MaxPlaytimeDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "minage")]
public record MinAgeDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "link")]
public record LinkDto
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; init; }

    [XmlAttribute(AttributeName = "value")]
    public string Value { get; init; }
}

[XmlRoot(ElementName = "statistics")]
public class StatisticsDto
{
    [XmlElement(ElementName = "ratings")]
    public RatingsDto Ratings { get; set; }

    [XmlAttribute(AttributeName = "page")]
    public int Page { get; set; }
}

[XmlRoot(ElementName = "ratings")]
public class RatingsDto
{
    [XmlElement(ElementName = "usersrated")]
    public UsersRate UsersRate { get; set; }

    [XmlElement(ElementName = "average")]
    public Average Average { get; set; }

    [XmlElement(ElementName = "bayesaverage")]
    public BuyersAverage BuyersAverage { get; set; }

    [XmlElement(ElementName = "ranks")]
    public GameRankings GameRankings { get; set; }

    [XmlElement(ElementName = "stddev")]
    public StandardDeviation StandardDeviation { get; set; }

    [XmlElement(ElementName = "median")]
    public Median Median { get; set; }

    [XmlElement(ElementName = "owned")]
    public TotalOwned TotalOwned { get; set; }

    [XmlElement(ElementName = "trading")]
    public TotalTrading TotalTrading { get; set; }

    [XmlElement(ElementName = "wanting")]
    public TotalWanting TotalWanting { get; set; }

    [XmlElement(ElementName = "wishing")]
    public TotalWishing TotalWishing { get; set; }

    [XmlElement(ElementName = "numcomments")]
    public TotalComments TotalComments { get; set; }

    [XmlElement(ElementName = "numweights")]
    public TotalWeights TotalWeights { get; set; }

    [XmlElement(ElementName = "averageweight")]
    public AverageWeight AverageWeight { get; set; }
}

[XmlRoot(ElementName = "usersrated")]
public class UsersRate
{

    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "average")]
public class Average
{

    [XmlAttribute(AttributeName = "value")]
    public double Value { get; set; }
}

[XmlRoot(ElementName = "bayesaverage")]
public class BuyersAverage
{

    [XmlAttribute(AttributeName = "value")]
    public double Value { get; set; }
}

[XmlRoot(ElementName = "rank")]
public class Ranking
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; set; }

    [XmlAttribute(AttributeName = "name")]
    public string Name { get; set; }

    [XmlAttribute(AttributeName = "friendlyname")]
    public string Friendlyname { get; set; }

    // MK It's mapped as a string because it can have a value of "Not Ranked"
    [XmlAttribute(AttributeName = "value")]
    public string Value { get; set; }

    // MK It's mapped as a string because it can have a value of "Not Ranked"
    [XmlAttribute(AttributeName = "bayesaverage")]
    public string BuyersAverage { get; set; }
}

[XmlRoot(ElementName = "ranks")]
public class GameRankings
{
    [XmlElement(ElementName = "rank")]
    public List<Ranking> Rankings { get; set; }
}

[XmlRoot(ElementName = "stddev")]
public class StandardDeviation
{
    [XmlAttribute(AttributeName = "value")]
    public double Value { get; set; }
}

[XmlRoot(ElementName = "median")]
public class Median
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "owned")]
public class TotalOwned
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "trading")]
public class TotalTrading
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "wanting")]
public class TotalWanting
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "wishing")]
public class TotalWishing
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "numcomments")]
public class TotalComments
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "numweights")]
public class TotalWeights
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "averageweight")]
public class AverageWeight
{
    [XmlAttribute(AttributeName = "value")]
    public double Value { get; set; }
}