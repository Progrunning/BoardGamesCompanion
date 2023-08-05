using System.Xml.Serialization;

namespace BGC.Core.Models.Dtos.BoardGameGeek;

[XmlRoot(ElementName = "name")]
public record BoardGameName
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "sortindex")]
    public int Sortindex { get; init; }

    [XmlAttribute(AttributeName = "value")]
    public string Name { get; init; }
}

[XmlRoot(ElementName = "minplayers")]
public record MinPlayers
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "maxplayers")]
public record MaxPlayers
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
public record PlayingTime
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "minplaytime")]
public record MinPlaytime
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "maxplaytime")]
public record MaxPlaytime
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "minage")]
public record Minage
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}

[XmlRoot(ElementName = "link")]
public record Link
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; init; }

    [XmlAttribute(AttributeName = "value")]
    public string Value { get; init; }
}

[XmlRoot(ElementName = "item")]
public record BoardGameDetailsDto
{
    [XmlElement(ElementName = "thumbnail")]
    public string Thumbnail { get; init; }

    [XmlElement(ElementName = "image")]
    public string Image { get; init; }

    [XmlElement(ElementName = "name")]
    public List<BoardGameName> Name { get; init; }

    [XmlElement(ElementName = "description")]
    public string Description { get; init; }

    [XmlElement(ElementName = "yearpublished")]
    public YearPublishedDto Yearpublished { get; init; }

    [XmlElement(ElementName = "minplayers")]
    public MinPlayers Minplayers { get; init; }

    [XmlElement(ElementName = "maxplayers")]
    public MaxPlayers Maxplayers { get; init; }

    [XmlElement(ElementName = "poll")]
    public List<Poll> Poll { get; init; }

    [XmlElement(ElementName = "playingtime")]
    public PlayingTime Playingtime { get; init; }

    [XmlElement(ElementName = "minplaytime")]
    public MinPlaytime Minplaytime { get; init; }

    [XmlElement(ElementName = "maxplaytime")]
    public MaxPlaytime Maxplaytime { get; init; }

    [XmlElement(ElementName = "minage")]
    public Minage Minage { get; init; }

    [XmlElement(ElementName = "link")]
    public List<Link> Link { get; init; }

    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; init; }
}

