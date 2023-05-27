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

        [BsonRequired]
        public string Type { get; init; } = null!;

        public string? Description { get; init; }

        public string? ThumbnailUrl { get; init; }

        public string? ImageUrl { get; init; }

        public double? Complexity { get; init; }

        public double? AverageRating { get; init; }

        public int? MinNumberOfPlayers { get; init; }

        public int? MaxNumberOfPlayers { get; init; }

        public int? MinPlaytimeInMinutes { get; init; }

        public int? MaxPlaytimeInMinutes { get; init; }

        public int? MinAgeInYears { get; init; }

        public int? PublishedYear { get; init; }

        public int? Rank { get; init; }

        public int? RankVotes { get; init; }

        public string? Url { get; init; }

        public IReadOnlyCollection<NamedEntity> Artists { get; init; } = Array.Empty<NamedEntity>();

        public IReadOnlyCollection<NamedEntity> Category { get; init; } = Array.Empty<NamedEntity>();

        public IReadOnlyCollection<NamedEntity> Designers { get; init; } = Array.Empty<NamedEntity>();

        public IReadOnlyCollection<NamedEntity> GameTypes { get; init; } = Array.Empty<NamedEntity>();

        public IReadOnlyCollection<NamedEntity> Mechanic { get; init; } = Array.Empty<NamedEntity>();

        public IReadOnlyCollection<NamedEntity> Publishers { get; init; } = Array.Empty<NamedEntity>();
        
        public IReadOnlyCollection<NamedEntity> Expansions { get; init; } = Array.Empty<NamedEntity>();
    }
}
