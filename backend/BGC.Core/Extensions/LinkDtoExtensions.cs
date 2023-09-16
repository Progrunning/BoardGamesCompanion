using BGC.Core.Models.Domain;
using BGC.Core.Models.Dtos.BoardGameGeek;

namespace BGC.Core.Extensions
{
    public static class LinkDtoExtensions
    {
        public static IReadOnlyCollection<NamedEntity> To(this IEnumerable<LinkDto> linkDtos, LinkDtoType linkDtoType)
        {
            return linkDtos.Where(l => string.Equals(l.Type, linkDtoType.ToTypeName(), StringComparison.OrdinalIgnoreCase))
                           .Select(l => new NamedEntity()
                           {
                               Id = l.Id.ToString(),
                               Name = l.Value,
                           })
                           .ToArray();
        }

        private static string? ToTypeName(this LinkDtoType linkDtoType)
        {
            switch (linkDtoType)
            {
                case LinkDtoType.Artist:
                    return Constants.BggApi.NamedEntities.Artists;
                case LinkDtoType.Publisher:
                    return Constants.BggApi.NamedEntities.Publisher;
                case LinkDtoType.Category:
                    return Constants.BggApi.NamedEntities.Category;
                case LinkDtoType.Mechanic:
                    return Constants.BggApi.NamedEntities.Mechanic;
                case LinkDtoType.Designer:
                    return Constants.BggApi.NamedEntities.Designer;
                case LinkDtoType.Expansion:
                    return Constants.BggApi.NamedEntities.Expansion;
            }

            return null;
        }
    }
}
