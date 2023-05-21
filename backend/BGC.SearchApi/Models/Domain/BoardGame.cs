namespace BGC.SearchApi.Models.Domain
{
    public record BoardGame 
    {
        public string Id { get; init; }
        
        public string Name { get; init; }
    }
}
