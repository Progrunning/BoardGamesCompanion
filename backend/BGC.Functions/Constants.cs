using System.Text.Json;

namespace BGC.CacheQueueFunction
{
    internal static class Constants
    {
        internal static JsonSerializerOptions CustomJsonSerializerOptions = new JsonSerializerOptions()
        {
            PropertyNameCaseInsensitive = true,
        };

        internal static class Configruration
        {
            internal static class Names
            {
                internal const string CacheQueueConnectionString = nameof(CacheQueueConnectionString);
                internal const string CacheQueueName = $"%{nameof(CacheQueueName)}%";
            }

            internal static class Http
            {
                internal static TimeSpan Timeout = TimeSpan.FromSeconds(5);
            }
        }
    }
}
