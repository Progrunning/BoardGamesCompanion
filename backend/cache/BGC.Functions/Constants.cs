namespace BGC.CacheQueueFunction
{
    internal static class Constants
    {
        internal static class Configruration
        {
            internal static class Names
            {
                internal const string CacheQueueConnectionString = nameof(CacheQueueConnectionString);
                internal const string CacheQueueName = $"%{nameof(CacheQueueName)}%";
            }
        }
    }
}
