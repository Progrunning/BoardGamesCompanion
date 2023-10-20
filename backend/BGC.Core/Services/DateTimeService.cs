using System.Diagnostics.CodeAnalysis;

using BGC.Core.Services.Interfaces;

namespace BGC.Core.Services
{
    [ExcludeFromCodeCoverage(Justification = "There's not really much to test here")]
    public class DateTimeService : IDateTimeService
    {
        public DateTimeOffset UtcOffsetNow => DateTimeOffset.UtcNow;
    }
}
