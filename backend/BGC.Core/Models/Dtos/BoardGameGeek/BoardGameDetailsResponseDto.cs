using System.Xml.Serialization;

namespace BGC.Core.Models.Dtos.BoardGameGeek;

[XmlRoot(ElementName = "items")]
public class BoardGameDetailsResponseDto
{
    [XmlElement(typeof(BoardGameDetailsDto), ElementName = "item")]
    public BoardGameDetailsDto[] BoardGames { get; init; } = Array.Empty<BoardGameDetailsDto>();
}

