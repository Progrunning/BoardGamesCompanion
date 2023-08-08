using System.Text.Json.Serialization;

namespace BGC.Core.Models.Dtos.BoardGameOracle
{
    public record LatestDto(
        [property: JsonPropertyName("max")] double? Max,
        [property: JsonPropertyName("mean")] double? Average,
        [property: JsonPropertyName("median")] double? Median,
        [property: JsonPropertyName("min")] double? Min,
        [property: JsonPropertyName("n")] int N,
        [property: JsonPropertyName("lowest_store_name")] string? LowestStoreName,
        [property: JsonPropertyName("lowest_store_short_name")] string? LowestStoreShortName
    );

    public record PriceDropDayDto(
        [property: JsonPropertyName("previous_price")] double? PreviousPrice,
        [property: JsonPropertyName("change_percent")] double? ChangePercent,
        [property: JsonPropertyName("change_value")] double? ChangeValue
    );

    public record PriceDropWeekDto(
        [property: JsonPropertyName("previous_price")] double? PreviousPrice,
        [property: JsonPropertyName("change_percent")] double? ChangePercent,
        [property: JsonPropertyName("change_value")] double? ChangeValue
    );

    public record StatisticsDto(
        [property: JsonPropertyName("latest")] LatestDto Latest,
        [property: JsonPropertyName("price_drop_day")] PriceDropDayDto PriceDropDay,
        [property: JsonPropertyName("price_drop_week")] PriceDropWeekDto PriceDropWeek,
        [property: JsonPropertyName("lowest_30d")] double? Lowest30d,
        [property: JsonPropertyName("lowest_30d_store")] string? Lowest30dStore,
        [property: JsonPropertyName("lowest_30d_date")] DateTime? Lowest30dDate,
        [property: JsonPropertyName("lowest_52w")] double? Lowest52w,
        [property: JsonPropertyName("lowest_52w_store")] string? Lowest52wStore,
        [property: JsonPropertyName("lowest_52w_date")] DateTime? Lowest52wDate
    );

    public record PriceStatisticsDto(
        [property: JsonPropertyName("region")] string Region,
        [property: JsonPropertyName("key")] string Key,
        [property: JsonPropertyName("slug")] string Slug,
        [property: JsonPropertyName("title")] string Title,
        [property: JsonPropertyName("bgg_id")] int BggId,
        [property: JsonPropertyName("url")] string Url,
        [property: JsonPropertyName("price_stats")] StatisticsDto PriceStats
    );


}
