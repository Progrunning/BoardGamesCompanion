using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddTransient<ISearchService, SearchService>();

var app = builder.Build();
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/search", ([FromQuery] string query, ISearchService searchService) => searchService.Search(query))
   .WithOpenApi();

app.Run();