using BGC.Core.Models.Dtos.BoardGameOracle;
using BGC.Core.Services.Interfaces;
using BGC.Core.Extensions;

using Microsoft.Extensions.Logging;
using System.Text.Json;
using System.Runtime.Serialization;
using BGC.Core.Models.Dtos.BoardGameGeek;
using System.Net;
using System;

namespace BGC.Core.Services
{
    /// <inheritdoc />
    public class BoardGameOracelService : IBoardGameOracleService
    {
        private readonly ILogger<BoardGameOracelService> _logger;
        private readonly HttpClient _httpClient;

        public BoardGameOracelService(ILogger<BoardGameOracelService> logger, HttpClient httpClient)
        {
            _logger = logger;
            _httpClient = httpClient;
        }

        /// <inheritdoc />
        public async Task<PriceStatisticsDto?> GetPriceStats(string bggId, RegionDto region)
        {
            if (string.IsNullOrWhiteSpace(bggId))
            {
                _logger.LogInformation($"Invalid {nameof(bggId)} parameter");
                return null;
            }

            var regionName = region.ToAbbreviation();
            if (string.IsNullOrWhiteSpace(regionName))
            {
                _logger.LogInformation($"Invalid {nameof(regionName)} parameter");
                return null;
            }

            try
            {
                _logger.LogInformation($"Retrieving regional {region.ToAbbreviation()} price statistics for a game {bggId}");

                var requestUri = new Uri($"{_httpClient.BaseAddress}boardgame?region={regionName}&bggid={bggId}&pricestats=1");
                var searchResponseStream = await _httpClient.GetStreamAsync(requestUri);
                var priceStatisticsDto = await JsonSerializer.DeserializeAsync<PriceStatisticsDto>(searchResponseStream);
                return priceStatisticsDto;
            }
            catch (Exception exception)
            {
                // MK Swallow the exception as this is not a critical path so failures are allowed                
                switch (exception)
                {
                    case HttpRequestException httpRequestException when httpRequestException.StatusCode == HttpStatusCode.NotFound:
                        _logger.LogInformation(exception, $"Prices for board game {bggId} in region {region.ToAbbreviation()} were not found");
                        break;

                    default:
                        _logger.LogWarning(exception, $"Failed to retrieve price statistics for board game {bggId} in region {region.ToAbbreviation()}");
                        break;
                }

            }

            return null;
        }
    }
}
