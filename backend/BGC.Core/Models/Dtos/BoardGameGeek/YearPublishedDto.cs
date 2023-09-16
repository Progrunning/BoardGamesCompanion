
using System.Xml.Serialization;

namespace BGC.Core.Models.Dtos.BoardGameGeek;

[XmlRoot(ElementName = "yearpublished")]
public record YearPublishedDto
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; init; }
}