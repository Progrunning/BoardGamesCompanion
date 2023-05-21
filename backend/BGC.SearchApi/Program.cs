using BGC.SearchApi.Common;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddProblemDetails();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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
});

app.Run();