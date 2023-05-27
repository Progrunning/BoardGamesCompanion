using MongoDB.Bson.Serialization.Attributes;

namespace BGC.SearchApi.Models.Domain
{
    public record BoardGame
    {
        [BsonId]
        [BsonElement("_id")]
        [BsonRequired]
        public string Id { get; init; } = null!;

        [BsonRequired]
        public string Name { get; init; } = null!;

        public string? Description { get; init; }

        public string? ThumbnailUrl { get; init; }

        [BsonElement("imageUrl")]
        public string? ImageUrl { get; init; }

        public double? Complexity { get; init; }

        public double? AverageRating { get; init; }

        [BsonElement("minPlayers")]
        public int? MinNumberOfPlayers { get; init; }

        [BsonElement("maxPlayers")]
        public int? MaxNumberOfPlayers { get; init; }

        [BsonElement("minTimeInMinutes")]
        public int? MinPlaytimeInMinutes { get; init; }

        [BsonElement("maxTimeInMinutes")]
        public int? MaxPlaytimeInMinutes { get; init; }

        public int? MinAgeInYears { get; init; }

        public int? PublishedYear { get; init; }

        public int? Rank { get; init; }

        public int? RankVotes { get; init; }

        public string? Url { get; init; }

        public IReadOnlyCollection<string> Artists { get; init; } = Array.Empty<string>();

        public IReadOnlyCollection<string> Category { get; init; } = Array.Empty<string>();

        public IReadOnlyCollection<string> Designers { get; init; } = Array.Empty<string>();

        public IReadOnlyCollection<string> Types { get; init; } = Array.Empty<string>();

        [BsonElement("mechanis")]
        public IReadOnlyCollection<string> Mechanisms { get; init; } = Array.Empty<string>();

        public IReadOnlyCollection<string> Publishers { get; init; } = Array.Empty<string>();
    }
}
