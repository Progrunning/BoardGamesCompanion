using Azure.Identity;

using BGC.Core.Models.Settings;
using BGC.Core.Repositories;
using BGC.Core.Repositories.Interfaces;
using BGC.Core.Services;
using BGC.Core.Services.Interfaces;
using BGC.SearchApi.Common;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Policies;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

using MongoDB.Bson.Serialization.Conventions;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);

if (!bool.TryParse(builder.Configuration[Constants.ConfigurationKeyNames.IsIntegrationTest], out var isIntegrationTest) || !isIntegrationTest)
{
    // MK Might require adding Access Policies to the user signed into Azure
    builder.Configuration.AddAzureKeyVault(
            new Uri($"https://{builder.Configuration[Constants.ConfigurationKeyNames.KeyVault]}.vault.azure.net/"),
            new DefaultAzureCredential());
}

var appSettingsConfigurationSection = builder.Configuration.GetSection(nameof(AppSettings));
builder.Services.AddOptions<CacheSettings>()
                .Bind(appSettingsConfigurationSection.GetSection(nameof(CacheSettings)))
                .ValidateDataAnnotations()
                .ValidateOnStart();
builder.Services.AddOptions<MongoDbSettings>()
                .Bind(appSettingsConfigurationSection.GetSection(nameof(MongoDbSettings)))
                .ValidateDataAnnotations()
                .ValidateOnStart();
builder.Services.AddOptions<ApiKeyAuthenticationSettings>()
                .Bind(appSettingsConfigurationSection.GetSection(nameof(ApiKeyAuthenticationSettings)))
                .ValidateDataAnnotations()
                .ValidateOnStart();

builder.Services.AddHealthChecks();
builder.Services.AddApplicationInsightsTelemetry();
builder.Services.Configure<TelemetryConfiguration>(config =>
{
#if DEBUG
    config.DisableTelemetry = true;
#endif
});

builder.Services.AddAuthentication()
                .AddScheme<ApiKeyAuthenticationSettings, ApiKeyAuthenticationHandler>(Constants.AuthenticationSchemes.ApiKey, null);
builder.Services.AddAuthorization();
builder.Services.AddProblemDetails();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddTransient<IMongoClient>((services) =>
{
    var mongoDbSettings = services.GetService<IOptions<MongoDbSettings>>();

    return new MongoClient(mongoDbSettings!.Value.ConnectionString);
});
builder.Services.AddSingleton<ICacheService, CacheService>();
builder.Services.AddTransient<IBoardGamesRepository, BoardGamesRepository>();
builder.Services.AddTransient<IErrorService, ErrorService>();
builder.Services.AddTransient<IBggService, BggService>();
builder.Services.AddTransient<ISearchService, SearchService>();
builder.Services.AddTransient<IDateTimeService, DateTimeService>();

builder.Services.AddHttpClient<IBggService, BggService>(client =>
{
    client.BaseAddress = new Uri(BGC.Core.Constants.BggApi.BaseXmlApiUrl);
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseExceptionHandler("/api/error");
}
else
{
    app.UseExceptionHandler("/api/error");
}

app.UseHttpsRedirection();
app.UseStatusCodePages(async statusCodeContext =>
{
    await Results.Problem(statusCode: statusCodeContext.HttpContext.Response.StatusCode)
                 .ExecuteAsync(statusCodeContext.HttpContext);
});
app.MapHealthChecks("api/search/health");

app.MapGet("api/search", [Authorize] ([FromQuery] string query, ISearchService searchService) => searchService.Search(query, CancellationToken.None))
    .WithOpenApi();

app.MapGet("api/error", (IErrorService errorService, HttpContext context) =>
{
    var exceptionHandlerFeature = context.Features.Get<IExceptionHandlerFeature>()!;
    return errorService.HandleError(exceptionHandlerFeature.Error);
}).ExcludeFromDescription();

var mongoDbConventionPack = new ConventionPack
{
    new CamelCaseElementNameConvention(),
};
ConventionRegistry.Register(BGC.Core.Constants.MongoDb.ConventionNames.CamelCase, mongoDbConventionPack, type => true);

app.Run();

/// <summary>
/// Entry point for the API.
/// </summary>
/// <remarks>MK Declaring <see cref="Program"/> as a partial class is required because otherwise the integration tests using WebApplicationFactory won't work.</remarks>
public partial class Program { }