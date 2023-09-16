using BGC.Core.Services.Interfaces;

namespace BGC.Core.Services
{
    public class DateTimeService : IDateTimeService
    {
        public DateTimeOffset UtcOffsetNow => DateTimeOffset.UtcNow;
    }
}
