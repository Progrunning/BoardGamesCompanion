using BGC.Core.Extensions;
using BGC.Core.Models.Dtos.BoardGameOracle;

namespace BGC.Core.UnitTests.Extensions
{
    public class RegionDtoExtensionsTests
    {
        [Theory]
        [InlineData(RegionDto.Australia, "au")]
        [InlineData(RegionDto.Canada, "ca")]
        [InlineData(RegionDto.UnitedStates, "us")]
        [InlineData(RegionDto.UnitedKingdom, "gb")]
        [InlineData(RegionDto.NewZealand, "nz")]
        public void ToAbbreviation_RegionDto_ConvertsToExpectedValue(RegionDto regionDto, string expectedAbbreviation)
        {
            var abbreviation = regionDto.ToAbbreviation();

            abbreviation.Should().Be(expectedAbbreviation);
        }
    }
}
