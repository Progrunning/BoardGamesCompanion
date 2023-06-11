using BGC.SearchApi.Common;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Policies;
using BGC.SearchApi.Repositories;
using BGC.SearchApi.Repositories.Interfaces;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

using MongoDB.Bson.Serialization.Conventions;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);

var appSettingsConfigurationSection = builder.Configuration.GetSection(nameof(AppSettings));
builder.Services.AddOptions<MongoDbSettings>()
                .Bind(appSettingsConfigurationSection.GetSection(nameof(MongoDbSettings)))
                .ValidateDataAnnotations()
                .ValidateOnStart();
builder.Services.AddOptions<ApiKeyAuthenticationSettings>()
                .Bind(appSettingsConfigurationSection.GetSection(nameof(ApiKeyAuthenticationSettings)))
                .ValidateDataAnnotations()
                .ValidateOnStart();

builder.Services.AddHttpContextAccessor();
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
builder.Services.AddTransient<IBoardGamesRepository, BoardGamesRepository>();
builder.Services.AddTransient<IErrorService, ErrorService>();
builder.Services.AddTransient<IBggService, BggService>();
builder.Services.AddTransient<ISearchService, SearchService>();

builder.Services.AddHttpClient<IBggService, BggService>(client =>
{
    client.BaseAddress = new Uri(Constants.BggApi.BaseUrl);
});

var app = builder.Build();

//app.UseAuthentication();

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

app.MapGet("api/search", [Authorize] ([FromQuery] string query, ISearchService searchService) => searchService.Search(query, CancellationToken.None))
    //.RequireAuthorization(Constants.AuthenticationSchemes.ApiKey)
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
ConventionRegistry.Register(Constants.MongoDb.ConventionNames.CamelCase, mongoDbConventionPack, type => true);

app.Run();

/// <summary>
/// Entry point for the API.
/// </summary>
/// <remarks>MK Having this is required because otherwise the integration tests using WebApplicationFactory won't work.</remarks>
public partial class Program { }