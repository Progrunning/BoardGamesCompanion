using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.Core.Models.Domain
{
    public record Prices
    {
        /// <summary>
        /// Prices from a specific region.
        /// </summary>
        /// <remarks><see cref="RegionDto"/> for the current list of supported pricing regions.</remarks>
        public string Region { get; init; } = null!;

        /// <summary>
        /// Latest highest price.
        /// </summary>
        public double? Highest { get; init; }

        /// <summary>
        /// Latest average price.
        /// </summary>
        public double? Average { get; init; }

        /// <summary>
        /// Latest median price.
        /// </summary>
        public double? Median { get; init; }

        /// <summary>
        /// Latest lowest price.
        /// </summary>
        public double? Lowest { get; init; }
        
        /// <summary>
        /// Latest lowest price store name.
        /// </summary>
        public string? LowestStoreName { get; init; }

        public double? Lowest30d { get; init; }

        public string? Lowest30dStore { get; init; }

        public DateTime? Lowest30dDate { get; init; }

        public double? Lowest52w { get; init; }

        public string? Lowest52wStore { get; init; }

        public DateTime? Lowest52wDate { get; init; }

    }
}
