using System.Xml.Serialization;

namespace BGC.Core.Models.Dtos.BoardGameGeek;

[XmlRoot(ElementName = "item")]
public record BoardGameSearchItemDto
{
    [XmlElement(ElementName = "name")]
    public BoardGameSearchItemNameDto Name { get; init; }

    [XmlElement(ElementName = "yearpublished")]
    public YearPublishedDto Yearpublished { get; init; }

    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; init; }
}

[XmlRoot(ElementName = "name")]
public class BoardGameSearchItemNameDto
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; init; }

    [XmlAttribute(AttributeName = "value")]
    public string Value { get; init; }
}