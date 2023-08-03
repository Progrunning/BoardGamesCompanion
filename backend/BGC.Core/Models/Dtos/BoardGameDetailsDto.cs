using System.Xml.Serialization;

[XmlRoot(ElementName = "name", Namespace = "")]
public class BoardGameName
{
    [XmlAttribute(AttributeName = "type", Namespace = "")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "sortindex", Namespace = "")]
    public int Sortindex { get; set; }

    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public string Name { get; set; }
}

[XmlRoot(ElementName = "yearpublished", Namespace = "")]
public class YearPublished
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "minplayers", Namespace = "")]
public class MinPlayers
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "maxplayers", Namespace = "")]
public class MaxPlayers
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "result", Namespace = "")]
public class Result
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public string Value { get; set; }

    [XmlAttribute(AttributeName = "numvotes", Namespace = "")]
    public int Numvotes { get; set; }

    [XmlAttribute(AttributeName = "level", Namespace = "")]
    public int Level { get; set; }
}

[XmlRoot(ElementName = "results", Namespace = "")]
public class Results
{
    [XmlElement(ElementName = "result", Namespace = "")]
    public List<Result> Result { get; set; }

    [XmlAttribute(AttributeName = "numplayers", Namespace = "")]
    public int Numplayers { get; set; }
}

[XmlRoot(ElementName = "poll", Namespace = "")]
public class Poll
{
    [XmlElement(ElementName = "results", Namespace = "")]
    public List<Results> Results { get; set; }

    [XmlAttribute(AttributeName = "name", Namespace = "")]
    public string Name { get; set; }

    [XmlAttribute(AttributeName = "title", Namespace = "")]
    public string Title { get; set; }

    [XmlAttribute(AttributeName = "totalvotes", Namespace = "")]
    public int Totalvotes { get; set; }
}

[XmlRoot(ElementName = "playingtime", Namespace = "")]
public class Playingtime
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "minplaytime", Namespace = "")]
public class Minplaytime
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "maxplaytime", Namespace = "")]
public class Maxplaytime
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "minage", Namespace = "")]
public class Minage
{
    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public int Value { get; set; }
}

[XmlRoot(ElementName = "link", Namespace = "")]
public class Link
{
    [XmlAttribute(AttributeName = "type", Namespace = "")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "id", Namespace = "")]
    public int Id { get; set; }

    [XmlAttribute(AttributeName = "value", Namespace = "")]
    public string Value { get; set; }
}

[XmlRoot(ElementName = "item", Namespace = "")]
public class BoardGameDetailsDto
{
    [XmlElement(ElementName = "thumbnail", Namespace = "")]
    public string Thumbnail { get; set; }

    [XmlElement(ElementName = "image", Namespace = "")]
    public string Image { get; set; }

    [XmlElement(ElementName = "name", Namespace = "")]
    public List<BoardGameName> Name { get; set; }

    [XmlElement(ElementName = "description", Namespace = "")]
    public string Description { get; set; }

    [XmlElement(ElementName = "yearpublished", Namespace = "")]
    public YearPublished Yearpublished { get; set; }

    [XmlElement(ElementName = "minplayers", Namespace = "")]
    public MinPlayers Minplayers { get; set; }

    [XmlElement(ElementName = "maxplayers", Namespace = "")]
    public MaxPlayers Maxplayers { get; set; }

    [XmlElement(ElementName = "poll", Namespace = "")]
    public List<Poll> Poll { get; set; }

    [XmlElement(ElementName = "playingtime", Namespace = "")]
    public Playingtime Playingtime { get; set; }

    [XmlElement(ElementName = "minplaytime", Namespace = "")]
    public Minplaytime Minplaytime { get; set; }

    [XmlElement(ElementName = "maxplaytime", Namespace = "")]
    public Maxplaytime Maxplaytime { get; set; }

    [XmlElement(ElementName = "minage", Namespace = "")]
    public Minage Minage { get; set; }

    [XmlElement(ElementName = "link", Namespace = "")]
    public List<Link> Link { get; set; }

    [XmlAttribute(AttributeName = "type", Namespace = "")]
    public string Type { get; set; }

    [XmlAttribute(AttributeName = "id", Namespace = "")]
    public int Id { get; set; }
}

