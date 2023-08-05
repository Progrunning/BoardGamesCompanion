using System.Xml.Serialization;

[XmlRoot(ElementName = "name")]
public class BoardGameName
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "sortindex")]
    public int Sortindex { get; set; }

    [XmlAttribute(AttributeName = "value")]
    public string Name { get; set; }
}

[XmlRoot(ElementName = "yearpublished")]
public class YearPublished
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "minplayers")]
public class MinPlayers
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "maxplayers")]
public class MaxPlayers
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "result")]
public class Result
{
    [XmlAttribute(AttributeName = "value")]
    public string Value { get; set; }

    [XmlAttribute(AttributeName = "numvotes")]
    public int Numvotes { get; set; }

    [XmlAttribute(AttributeName = "level")]
    public int Level { get; set; }
}

[XmlRoot(ElementName = "results")]
public class Results
{
    [XmlElement(ElementName = "result")]
    public List<Result> Result { get; set; }

    [XmlAttribute(AttributeName = "numplayers")]
    public string Numplayers { get; set; }
}

[XmlRoot(ElementName = "poll")]
public class Poll
{
    [XmlElement(ElementName = "results")]
    public List<Results> Results { get; set; }

    [XmlAttribute(AttributeName = "name")]
    public string Name { get; set; }

    [XmlAttribute(AttributeName = "title")]
    public string Title { get; set; }

    [XmlAttribute(AttributeName = "totalvotes")]
    public int Totalvotes { get; set; }
}

[XmlRoot(ElementName = "playingtime")]
public class Playingtime
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "minplaytime")]
public class Minplaytime
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "maxplaytime")]
public class Maxplaytime
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "minage")]
public class Minage
{
    [XmlAttribute(AttributeName = "value")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "link")]
public class Link
{
    [XmlAttribute(AttributeName = "type")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; set; }

    [XmlAttribute(AttributeName = "value")]
    public string Value { get; set; }
}

[XmlRoot(ElementName = "item")]
public class BoardGameDetailsDto
{
    [XmlElement(ElementName = "thumbnail")]
    public string Thumbnail { get; set; }

    [XmlElement(ElementName = "image")]
    public string Image { get; set; }

    [XmlElement(ElementName = "name")]
    public List<BoardGameName> Name { get; set; }

    [XmlElement(ElementName = "description")]
    public string Description { get; set; }

    [XmlElement(ElementName = "yearpublished")]
    public YearPublished Yearpublished { get; set; }

    [XmlElement(ElementName = "minplayers")]
    public MinPlayers Minplayers { get; set; }

    [XmlElement(ElementName = "maxplayers")]
    public MaxPlayers Maxplayers { get; set; }

    [XmlElement(ElementName = "poll")]
    public List<Poll> Poll { get; set; }

    [XmlElement(ElementName = "playingtime")]
    public Playingtime Playingtime { get; set; }

    [XmlElement(ElementName = "minplaytime")]
    public Minplaytime Minplaytime { get; set; }

    [XmlElement(ElementName = "maxplaytime")]
    public Maxplaytime Maxplaytime { get; set; }

    [XmlElement(ElementName = "minage")]
    public Minage Minage { get; set; }

    [XmlElement(ElementName = "link")]
    public List<Link> Link { get; set; }

    [XmlAttribute(AttributeName = "type")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "id")]
    public int Id { get; set; }
}

