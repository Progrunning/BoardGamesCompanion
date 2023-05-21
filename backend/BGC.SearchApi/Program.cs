using BGC.SearchApi.Common;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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

app.UseHttpsRedirection();

app.MapGet("api/search", ([FromQuery] string query, ISearchService searchService) => searchService.Search(query, CancellationToken.None))
   .WithOpenApi();

app.Run();