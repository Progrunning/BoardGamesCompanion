using System.Text.Json;

using Azure.Messaging.ServiceBus;

using BGC.Core.Services.Interfaces;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.Extensions.Options;

namespace BGC.SearchApi.Services
{
    /// <inheritdoc />
    public class CacheService : ICacheService
    {
        private const string OperationTypePropertyName = "operationType";

        private const string AppOperationName = "add";
        private const string UpdateOperationName = "update";

        /// <summary>
        /// A delay has been introduced as there were instances where BGG were returning 429 because of the number of requests made when searching.
        /// An arbitrary number of 10 seconds has been introduced to "space" out the creation and consumption of the messages to allow for
        /// better distribution.
        /// </summary>
        private static readonly TimeSpan MessageSeparationDelay = TimeSpan.FromSeconds(10);

        private readonly ServiceBusClient _client;
        private readonly ServiceBusSender _sender;
        private readonly IOptions<CacheSettings> _cacheSettings;
        private readonly ILogger<CacheService> _logger;
        private readonly IDateTimeService _dateTimeService;

        /// <summary>
        /// Initializes a new instance of the <see cref="CacheService"/> class.
        /// </summary>
        /// <param name="cacheSettings"></param>
        /// <param name="dateTimeService"></param>
        /// <param name="logger"></param>
        public CacheService(IOptions<CacheSettings> cacheSettings, IDateTimeService dateTimeService, ILogger<CacheService> logger)
        {
            var clientOptions = new ServiceBusClientOptions()
            {
                TransportType = ServiceBusTransportType.AmqpWebSockets,
            };
            _client = new ServiceBusClient(cacheSettings.Value.SendConnectionString, clientOptions);
            _sender = _client.CreateSender(cacheSettings.Value.QueueName);
            _cacheSettings = cacheSettings;
            _dateTimeService = dateTimeService;
            _logger = logger;
        }

        /// <inheritdoc />
        public int CacheExpirationInMinutes => _cacheSettings.Value.CacheExpirationInMinutes;

        /// <inheritdoc />
        public async Task Add(IEnumerable<string> boardGameIds)
        {
            await SendMessagesToCacheQueue(boardGameIds, AppOperationName);
        }

        /// <inheritdoc />
        public async Task Update(IEnumerable<string> boardGameIds)
        {
            await SendMessagesToCacheQueue(boardGameIds, UpdateOperationName);
        }

        private async Task SendMessagesToCacheQueue(IEnumerable<string> boardGameIds, string operationName)
        {
            if (!boardGameIds.Any())
            {
                return;
            }

            var messageSeparationDelay = _dateTimeService.UtcOffsetNow;

            using ServiceBusMessageBatch messageBatch = await _sender.CreateMessageBatchAsync();

            foreach (var boardGameId in boardGameIds)
            {
                var payload = new { boardGameId = boardGameId };
                var message = new ServiceBusMessage(JsonSerializer.Serialize(payload));
                message.ScheduledEnqueueTime = messageSeparationDelay;
                message.ApplicationProperties[OperationTypePropertyName] = operationName;
                if (!messageBatch.TryAddMessage(message))
                {
                    _logger.LogError($"Failed to add message to the batch for the board game {boardGameId}");
                    continue;
                }

                messageSeparationDelay = messageSeparationDelay.Add(MessageSeparationDelay);
            }

            try
            {
                _logger.LogInformation($"Sending board games {string.Join(",", boardGameIds)} to the queue for caching...");
                await _sender.SendMessagesAsync(messageBatch);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Failed to send message to the queue for caching.");
            }
        }
    }
}
