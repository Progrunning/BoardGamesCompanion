using System.Net;
using System.Net.Http.Json;

using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestPlatform.TestHost;

namespace BGC.SearchApi.UnitTests.Endpoints
{
    public class SearchEndpointTests
    {
        private readonly Mock<ISearchService> _mockSearchService;

        public SearchEndpointTests()
        {
            _mockSearchService = new Mock<ISearchService>();
        }

        [Fact]
        public async Task Search_NoResultsFound_ReturnsEmptyCollection()
        {
            var searchQuery = "Scythe";
            _mockSearchService.Setup(service => service.Search(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(Array.Empty<BoardGameSummaryDto>());
            await using var application = new WebApplicationFactory<Program>()
                .WithWebHostBuilder(builder => builder.ConfigureServices(services =>
                {
                    services.AddTransient<ISearchService>((services) => _mockSearchService.Object);
                }));
            using var client = application.CreateClient();

            var response = await client.GetFromJsonAsync<IReadOnlyCollection<BoardGameSummaryDto>>($"api/search?query={searchQuery}");

            _mockSearchService.Verify(service => service.Search(searchQuery, It.IsAny<CancellationToken>()), Times.Once);
            response.Should().BeEmpty();
        }

        [Fact]
        public async Task Search_SearchFailure_ThrowsBadRequestException()
        {
            _mockSearchService.Setup(service => service.Search(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                .ThrowsAsync(new BggException((int)HttpStatusCode.BadRequest, "Dunno, some failure"));
            await using var application = new WebApplicationFactory<Program>()
                .WithWebHostBuilder(builder => builder.ConfigureServices(services =>
                {
                    services.AddTransient<ISearchService>((services) => _mockSearchService.Object);
                }));
            using var client = application.CreateClient();

            var searchFunc = async () => await client.GetFromJsonAsync<ProblemDetails>("api/search?query=Scythe");
            await searchFunc.Should().ThrowAsync<HttpRequestException>().Where(exception => exception.StatusCode == HttpStatusCode.BadRequest);
        }
    }
}
