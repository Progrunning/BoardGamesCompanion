using Azure.Identity;

using BGC.Core.Extensions;
using BGC.Core.Helpers;
using BGC.Core.Models.Settings;
using BGC.Core.Services;
using BGC.Core.Services.Interfaces;
using BGC.SearchApi.Common;
using BGC.SearchApi.Models.Settings;
using BGC.SearchApi.Policies;
using BGC.SearchApi.Services;
using BGC.SearchApi.Services.Interface;
using BGC.SearchApi.Services.Interfaces;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

using MongoDB.Driver;

using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

using Serilog;
using Serilog.Events;

// Setup bootstrap logger to log any startup errors before the full host is built and Serilog is configured,
// then reconfigure Serilog after building the host so that the full configuration from appsettings and DI is applied.
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .CreateLogger();

try
{
    Log.Information("Starting up...");
    var builder = WebApplication.CreateBuilder(args);

    ConfigureOpenTelemetry(builder, builder.Configuration);

    builder.Services.AddOptions<CacheSettings>()
                .Bind(builder.Configuration.GetSection(nameof(CacheSettings)))
                .ValidateDataAnnotations()
                .ValidateOnStart();
    builder.Services.AddOptions<ApiKeyAuthenticationSettings>()
                    .Bind(builder.Configuration.GetSection(nameof(ApiKeyAuthenticationSettings)))
                    .ValidateDataAnnotations()
                    .ValidateOnStart();

    builder.Services.AddHealthChecks();

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
    builder.Services.AddCoreServices();
    builder.Services.AddSingleton<ICacheService, CacheService>();
    builder.Services.AddTransient<IErrorService, ErrorService>();
    builder.Services.AddTransient<ISearchService, SearchService>();
    builder.Services.AddTransient<IDateTimeService, DateTimeService>();

    var app = builder.Build();

    app.UseSerilogRequestLogging();

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
    app.MapHealthChecks("/healthz")
       .ShortCircuit();

    app.MapGet("api/search", [Authorize] ([FromQuery] string query, ISearchService searchService) => searchService.Search(query, CancellationToken.None))
       .WithOpenApi();

    app.MapGet("api/error", (IErrorService errorService, HttpContext context) =>
    {
        var exceptionHandlerFeature = context.Features.Get<IExceptionHandlerFeature>()!;
        return errorService.HandleError(exceptionHandlerFeature.Error);
    }).ExcludeFromDescription();

    MongoDbHelpers.RegisterConventions();

    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Application terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}

static void ConfigureOpenTelemetry(WebApplicationBuilder builder, IConfiguration configuration)
{
    var otlpEndpoint = configuration[Constants.Telemetry.Config.OtlpEndpoint]
        ?? throw new InvalidOperationException($"{Constants.Telemetry.Config.OtlpEndpoint} configuration is required for telemetry to work");

    builder.Services.AddSerilog((services, loggerConfig) => loggerConfig
            .ReadFrom.Configuration(builder.Configuration)
            .ReadFrom.Services(services)
            .Enrich.FromLogContext()
            .WriteTo.Console() // Optional: Keep local console logs
            .WriteTo.OpenTelemetry(options =>
            {
                options.Endpoint = otlpEndpoint;
                options.Protocol = Serilog.Sinks.OpenTelemetry.OtlpProtocol.Grpc; // Or HttpProtobuf
                options.ResourceAttributes = new Dictionary<string, object>
                {
                    [Constants.Telemetry.Attributes.ServiceName] = Constants.Telemetry.ServiceName,
                };
            }));

    builder.Services.AddOpenTelemetry()
        .ConfigureResource(resource => resource.AddService(Constants.Telemetry.ServiceName))
        .WithTracing(tracing => tracing
            .AddAspNetCoreInstrumentation() // Captures incoming HTTP request traces
            .AddHttpClientInstrumentation() // Captures outgoing HTTP client traces            
            .AddOtlpExporter(options => options.Endpoint = new Uri(otlpEndpoint)))
        .WithMetrics(metrics => metrics
            .AddAspNetCoreInstrumentation() // Captures request rates and durations
            .AddHttpClientInstrumentation()
            .AddOtlpExporter(options => options.Endpoint = new Uri(otlpEndpoint)));
}

/// <summary>
/// Entry point for the API.
/// </summary>
/// <remarks>MK Declaring <see cref="Program"/> as a partial class is required because otherwise the integration tests using WebApplicationFactory won't work.</remarks>
public partial class Program { }