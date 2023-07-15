using System.Net;
using System.Net.Http.Json;

using BGC.SearchApi.Common;
using BGC.SearchApi.Models.Dtos;
using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Policies;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.UnitTests.Helpers;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;

namespace BGC.SearchApi.UnitTests.Endpoints
{
    public class SearchEndpointTests
    {
        private const string InvalidApiKey = "invalid-api-key";

        private readonly Mock<ISearchService> _mockSearchService;

        public SearchEndpointTests()
        {
            _mockSearchService = new Mock<ISearchService>();
        }


        [Fact]
        public async Task Search_NoApiKey_ThrowsUnauthorizedException()
        {
            var searchQuery = "Scythe";
            await using var application = new WebApiApp()
                .WithWebHostBuilder(builder => builder.ConfigureServices(services =>
                {
                    services.AddTransient<ISearchService>((services) => _mockSearchService.Object);
                }));
            using var client = application.CreateClient();

            var searchFunc = async () => await client.GetFromJsonAsync<ProblemDetails>("api/search?query=Scythe");
            (await searchFunc.Should().ThrowAsync<HttpRequestException>())
                .Which.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        }

        [Fact]
        public async Task Search_InvalidApiKey_ThrowsUnauthorizedException()
        {
            var searchQuery = "Scythe";
            await using var application = new WebApiApp()
                .WithWebHostBuilder(builder => builder.ConfigureServices(services =>
                {
                    services.AddTransient<ISearchService>((services) => _mockSearchService.Object);
                    services.AddScoped<ApiKeyAuthenticationSettings>((settings) => new ApiKeyAuthenticationSettings() { ApiKey = InvalidApiKey });
                }));
            using var client = application.CreateClient();

            var searchFunc = async () => await client.GetFromJsonAsync<ProblemDetails>($"api/search?query={searchQuery}");
            (await searchFunc.Should().ThrowAsync<HttpRequestException>())
                .Which.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        }

        [Fact]
        public async Task Search_NoResultsFound_ReturnsEmptyCollection()
        {
            var searchQuery = "Scythe";
            _mockSearchService.Setup(service => service.Search(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(Array.Empty<BoardGameSummaryDto>());
            await using var application = new WebApiApp()
                .WithWebHostBuilder(builder => builder.ConfigureServices(services =>
                {
                    services.AddTransient<ISearchService>((services) => _mockSearchService.Object);
                }));
            using var client = application.CreateClient();
            client.DefaultRequestHeaders.Add(Constants.Headers.ApiKey, WebApiApp.ApiKey);

            var response = await client.GetFromJsonAsync<IReadOnlyCollection<BoardGameSummaryDto>>($"api/search?query={searchQuery}");

            _mockSearchService.Verify(service => service.Search(searchQuery, It.IsAny<CancellationToken>()), Times.Once);
            response.Should().BeEmpty();
        }

        [Fact]
        public async Task Search_SearchFailure_ThrowsBadRequestException()
        {
            _mockSearchService.Setup(service => service.Search(It.IsAny<string>(), It.IsAny<CancellationToken>()))
                .ThrowsAsync(new BggException((int)HttpStatusCode.BadRequest, "Dunno, some failure"));
            await using var application = new WebApiApp()
                .WithWebHostBuilder(builder => builder.ConfigureServices(services =>
                {
                    services.AddTransient<ISearchService>((services) => _mockSearchService.Object);
                }));
            using var client = application.CreateClient();
            client.DefaultRequestHeaders.Add(Constants.Headers.ApiKey, WebApiApp.ApiKey);

            var searchFunc = async () => await client.GetFromJsonAsync<ProblemDetails>("api/search?query=Scythe");
            (await searchFunc.Should().ThrowAsync<HttpRequestException>())
                .Which.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        }
    }
}
