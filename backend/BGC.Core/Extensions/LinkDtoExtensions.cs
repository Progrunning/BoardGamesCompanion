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
                    return "boardgameartist";
                case LinkDtoType.Publisher:
                    return "boardgamepublisher";
                case LinkDtoType.Category:
                    return "boardgamecategory";
                case LinkDtoType.Mechanic:
                    return "boardgamemechanic";
                case LinkDtoType.Designer:
                    return "boardgamedesigner";
                case LinkDtoType.Expansion:
                    return "boardgameexpansion";
            }

            return null;
        }
    }
}
