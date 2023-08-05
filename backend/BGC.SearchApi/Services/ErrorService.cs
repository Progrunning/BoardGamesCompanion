using System.Net;

using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Services.Interfaces;

namespace BGC.SearchApi.Services
{
    public class ErrorService : IErrorService
    {
        private readonly ILogger<ErrorService> _logger;

        public ErrorService(ILogger<ErrorService> logger)
        {
            _logger = logger;
        }

        public IResult HandleError(Exception excption)
        {
            switch (excption)
            {
                case BggException bggException:
                    return Microsoft.AspNetCore.Http.Results.Problem(title: bggException.Message, statusCode: bggException.HttpStatus);
                default:
                    return Microsoft.AspNetCore.Http.Results.StatusCode((int)HttpStatusCode.InternalServerError);
            }
        }
    }
}
