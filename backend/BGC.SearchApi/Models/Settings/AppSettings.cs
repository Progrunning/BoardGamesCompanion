namespace BGC.SearchApi.Models.Settings
{
    public record AppSettings
    {
        public MongoDbSettings? MongoDb { get; init; }
    }
}
