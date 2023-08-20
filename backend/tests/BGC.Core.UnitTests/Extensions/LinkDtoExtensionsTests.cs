using AutoFixture;

using BGC.Core;
using BGC.Core.Extensions;
using BGC.Core.Models.Dtos.BoardGameGeek;

public class LinkDtoExtensionsTests
{
    private readonly Fixture fixture = new Fixture();

    [Fact]
    public void ToDomain_DtoObjects_ConvertsToDomain()
    {
        var dtos = fixture.Build<LinkDto>()
                          .With(link => link.Type, Constants.BggApi.NamedEntities.Expansion)
                          .CreateMany();

        var domainModels = dtos.To(LinkDtoType.Expansion);

        domainModels.Should().NotBeNull();
        domainModels.Should().HaveCount(dtos.Count());
    }
}