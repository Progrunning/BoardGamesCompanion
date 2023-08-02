using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace BGC.CacheQueueFunction.Functions
{
    public class CacheQueueWorkerFunction
    {
        private readonly ILogger _logger;

        public CacheQueueWorkerFunction(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<CacheQueueWorkerFunction>();
        }

        [Function(nameof(CacheQueueWorkerFunction))]
        public void Run([ServiceBusTrigger(
            Constants.Configruration.Names.CacheQueueName,
            Connection = Constants.Configruration.Names.CacheQueueConnectionString)] string queueMessage)
        {
            _logger.LogInformation($"C# ServiceBus topic trigger function processed message: {queueMessage}");
        }
    }
}
