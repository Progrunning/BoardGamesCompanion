using Azure.Messaging.ServiceBus;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services.Interfaces;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using BGC.CacheQueueFunction;
using BGC.CacheCore;

namespace BGC.Functions.Functions
{
    public class UpdateBoardGameCacheFunction : BaseUpdateBoardGameCacheService<UpdateBoardGameCacheFunction>
    {
        public UpdateBoardGameCacheFunction(
            ILogger<UpdateBoardGameCacheFunction> logger,
            IBggService bggService,
            IBoardGamesRepository boardGamesRepository,
            IBoardGameOracleService boardGameOracleService)
            : base(logger, bggService, boardGamesRepository, boardGameOracleService)
        {
        }

        [Function(nameof(UpdateBoardGameCacheFunction))]
        public async Task Run([ServiceBusTrigger(Constants.Configruration.Names.CacheQueueName, Connection = Constants.Configruration.Names.CacheQueueConnectionString)]
            ServiceBusReceivedMessage queueMessage)
        {
            await ProcessUpdateCacheMessage(queueMessage);
        }
    }
}
