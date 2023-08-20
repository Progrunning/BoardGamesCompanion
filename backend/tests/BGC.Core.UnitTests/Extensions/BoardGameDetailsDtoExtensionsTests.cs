using AutoFixture;

using BGC.Core.Extensions;
using BGC.Core.Models.Dtos.BoardGameGeek;

namespace BGC.Core.UnitTests.Extensions;

public class BoardGameDetailsDtoExtensionsTests
{
    private readonly Fixture fixture = new Fixture();

    [Fact]
    public void ToDomain_DtoObjectWithPrimaryName_ConvertsToDomain()
    {
        var dto = fixture.Build<BoardGameDetailsDto>()
                         .With(details => details.NameElements, new List<BoardGameNameDto>()
                         {
                             new BoardGameNameDto()
                             {
                                 Name = "Best board game ever",
                                 Type = "primary",
                             },
                         })
                         .Create();

        var domain = dto.ToDomain(null);

        domain.Should().NotBeNull();
        domain.Id.Should().Be(dto.Id.ToString());
        domain.Name.Should().Be(dto.PrimaryName);
    }
}
