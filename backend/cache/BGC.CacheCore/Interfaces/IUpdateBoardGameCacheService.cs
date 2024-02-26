using Azure.Messaging.ServiceBus;

namespace BGC.CacheCore.Interfaces
{
    public interface IUpdateBoardGameCacheService
    {
        /// <summary>
        /// Processes update board game cache information service bus message.
        /// </summary>
        /// <param name="queueMessage"></param>
        /// <returns></returns>
        Task ProcessUpdateCacheMessage(ServiceBusReceivedMessage queueMessage);
    }
}
