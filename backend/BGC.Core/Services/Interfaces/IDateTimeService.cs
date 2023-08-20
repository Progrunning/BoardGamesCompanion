namespace BGC.Core.Services.Interfaces;

/// <summary>
/// Date time service.
/// </summary>
public interface IDateTimeService
{
    /// <summary>
    /// Gets <see cref="DateTimeOffset"/> for UTC now.
    /// </summary>
    DateTimeOffset UtcOffsetNow { get; }
}
