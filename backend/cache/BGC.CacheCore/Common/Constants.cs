using System.Text.Json;

namespace BGC.CacheCore.Common
{
    internal class Constants
    {
        internal static JsonSerializerOptions CustomJsonSerializerOptions = new JsonSerializerOptions()
        {
            PropertyNameCaseInsensitive = true,
        };
    }
}
