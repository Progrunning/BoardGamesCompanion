using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.Core.Services.Interfaces
{
    /// <summary>
    /// Board Game Oracle API service.
    /// </summary>
    public interface IBoardGameOracleService
    {

        /// <summary>
        /// Get price stats for a game in a region.
        /// </summary>
        /// <param name="bggId">Board Games Geek id</param>
        /// <param name="region">Prices for a <see cref="RegionDto"/></param>
        /// <returns></returns>
        Task<PriceStatisticsDto?> GetPriceStats(string bggId, RegionDto region);        
    }
}
