namespace BGC.SearchApi.Models.Settings
{
    public record MongoDbSettings
    {
        public string? ConnectionString { get; init; }
    }
}
