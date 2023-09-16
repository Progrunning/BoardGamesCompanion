namespace BGC.SearchApi.Models.Dtos
{
    public record BoardGameSummaryPriceDto
    {
        /// <summary>
        /// Region of the prices.
        /// </summary>
        public string Region { get; init; } = null!;

        /// <summary>
        /// Website link to the board game price list.
        /// </summary>
        public string WebsiteUrl { get; init; } = null!;

        public double? LowestPrice { get; init; }

        public string? LowestPriceStoreName { get; init; }
    }
}
