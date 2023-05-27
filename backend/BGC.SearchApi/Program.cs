using BGC.SearchApi.Common;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Repositories;
using BGC.SearchApi.Repositories.Interfaces;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

using MongoDB.Bson.Serialization.Conventions;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddProblemDetails();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.Configure<AppSettings>(builder.Configuration.GetSection(nameof(AppSettings)));
builder.Services.AddTransient<IMongoClient>((services) =>
{
    var appSettings = services.GetService<IOptions<AppSettings>>();
    
    return new MongoClient(appSettings!.Value.MongoDb!.ConnectionString);
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
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
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

app.MapGet("api/search", ([FromQuery] string query, ISearchService searchService) => searchService.Search(query, CancellationToken.None))
   .WithOpenApi();

app.MapGet("api/error", (IErrorService errorService, HttpContext context) =>
{
    var exceptionHandlerFeature = context.Features.Get<IExceptionHandlerFeature>()!;
    return errorService.HandleError(exceptionHandlerFeature.Error);
}).ExcludeFromDescription();

var mongoDbConventionPack = new ConventionPack
{
    new CamelCaseElementNameConvention()
};
ConventionRegistry.Register(Constants.MongoDb.ConventionNames.CamelCase, mongoDbConventionPack, type => true);

app.Run();