using System.Xml.Serialization;

namespace BGC.Core.Models.Dtos.BoardGameGeek;

[XmlRoot(ElementName = "items")]
public class BoardGameSearchResponseDto
{
    [XmlElement(typeof(BoardGameSearchItemDto), ElementName = "item")]
    public BoardGameSearchItemDto[] BoardGames { get; init; } = Array.Empty<BoardGameSearchItemDto>();

    [XmlAttribute(AttributeName = "total")]
    public int Total { get; set; }

    [XmlAttribute(AttributeName = "termsofuse")]
    public string TermsOfUse { get; set; }
}