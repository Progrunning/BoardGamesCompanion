using BGC.Core.Models.Dtos.BoardGameOracle;
using BGC.Core.Services.Interfaces;
using BGC.Core.Extensions;

using Microsoft.Extensions.Logging;

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
        public async Task<PriceStatisticsDto> GetPriceStats(string bggId, RegionDto region)
        {
            if (string.IsNullOrWhiteSpace(bggId))
            {
                throw new ArgumentNullException(nameof(bggId));
            }

            var regionName = region.ToAbbreviation();
            if (string.IsNullOrWhiteSpace(regionName))
            {
                throw new ArgumentNullException(nameof(regionName));
            }

            var requestUri = new Uri($"{_httpClient.BaseAddress}/boardgame?region={regionName}&bggid={bggId}&pricestats=1");
            var searchResponseStream = await _httpClient.GetStreamAsync(requestUri);
            // TODO Deserialize
        }
    }
}
