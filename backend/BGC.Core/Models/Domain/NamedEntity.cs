using System.Diagnostics.CodeAnalysis;

using MongoDB.Bson.Serialization.Attributes;

namespace BGC.Core.Models.Domain
{
    [BsonNoId]
    [ExcludeFromCodeCoverage(Justification = "Simple domain models don't require testing")]
    public record NamedEntity
    {
        [BsonRequired]
        public string Id { get; init; } = null!;

        [BsonRequired]
        public string Name { get; init; } = null!;
    };
}
