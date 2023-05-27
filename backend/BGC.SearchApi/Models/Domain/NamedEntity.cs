using MongoDB.Bson.Serialization.Attributes;

namespace BGC.SearchApi.Models.Domain
{
    [BsonNoId]
    public record NamedEntity
    {        
        [BsonRequired]
        public string Id { get; init; } = null!;

        [BsonRequired]
        public string Name { get; init; } = null!;
    };
}
