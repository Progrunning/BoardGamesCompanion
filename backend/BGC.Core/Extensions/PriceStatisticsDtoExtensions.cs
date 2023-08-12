using BGC.Core.Models.Domain;
using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.Core.Extensions
{
    public static class PriceStatisticsDtoExtensions
    {
        public static IReadOnlyCollection<Prices> ToDomain(this IReadOnlyCollection<PriceStatisticsDto>? regionalPriceStatistics)
        {
            if (regionalPriceStatistics is null || !regionalPriceStatistics.Any())
            {
                return Array.Empty<Prices>();
            }

            return regionalPriceStatistics.Select(rps => new Prices()
            {
                Region = rps.Region,
                WebsiteUrl = rps.Url,
                Highest = rps.PriceStats.Latest.Max,
                Average = rps.PriceStats.Latest.Average,
                Median = rps.PriceStats.Latest.Median,
                Lowest = rps.PriceStats.Latest.Min,
                LowestStoreName = rps.PriceStats.Latest.LowestStoreName,
                Lowest30d = rps.PriceStats.Lowest30d,
                Lowest30dStore = rps.PriceStats.Lowest30dStore,
                Lowest30dDate = rps.PriceStats.Lowest30dDate,
                Lowest52w = rps.PriceStats.Lowest52w,
                Lowest52wStore = rps.PriceStats.Lowest52wStore,
                Lowest52wDate = rps.PriceStats.Lowest52wDate,
            }).ToArray();
        }
    }
}
