using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace BGC.Functions
{
    public class GameDetailsFunction
    {
        private readonly ILogger _logger;

        public GameDetailsFunction(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<GameDetailsFunction>();
        }

        [Function("Details")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.System, "get", Route = "games/{id:string}")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            response.WriteString("Welcome to Azure Functions!");

            return response;
        }
    }
}
