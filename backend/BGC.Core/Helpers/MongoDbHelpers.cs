using MongoDB.Bson.Serialization.Conventions;

namespace BGC.Core.Helpers
{
    public static class MongoDbHelpers
    {
        public static void RegisterConventions()
        {
            var mongoDbConventionPack = new ConventionPack
            {
                new CamelCaseElementNameConvention(),
            };
            ConventionRegistry.Register(Constants.MongoDb.ConventionNames.CamelCase, mongoDbConventionPack, type => true);
        }
    }
}
