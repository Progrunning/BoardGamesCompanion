using System.Text;
using System.Text.Json;

namespace BGC.Tests.Core.Extensions
{
    public static class GenericExtensions
    {
        public static byte[] ToByteArray<T>(this T model)
            where T : class
        {
            return Encoding.UTF8.GetBytes(JsonSerializer.Serialize(model));
        }
    }
}
