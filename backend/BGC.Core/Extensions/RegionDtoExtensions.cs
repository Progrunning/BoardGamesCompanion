using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.Core.Extensions
{
    public static class RegionDtoExtensions
    {
        public static string? ToAbbreviation(this RegionDto regionDto)
        {
            switch (regionDto)
            {
                case RegionDto.Australia:
                    return "au";
                case RegionDto.NewZealand:
                    return "nz";
                case RegionDto.UnitedStates:
                    return "us";
                case RegionDto.Canada:
                    return "ca";
                case RegionDto.UnitedKingdom:
                    return "gb";
            }

            return null;
        }
    }
}
