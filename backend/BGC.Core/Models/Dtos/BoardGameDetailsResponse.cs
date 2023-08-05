using System.Xml.Serialization;

namespace BGC.Core.Models.Dtos
{
    [XmlRoot(ElementName = "items")]
    public class BoardGameDetailsResponse
    {
        [XmlElement(typeof(BoardGameDetailsDto), ElementName = "item")]
        public BoardGameDetailsDto[] BoardGames { get; init; } = Array.Empty<BoardGameDetailsDto>();
    }
}
