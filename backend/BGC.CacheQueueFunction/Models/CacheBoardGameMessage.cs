namespace BGC.CacheQueueFunction.Models
{
    public record CacheBoardGameMessage
    {
        public required string BoardGameId { get; init; }
    }
}
