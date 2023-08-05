using System.Net;

using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Services.Interfaces;

namespace BGC.SearchApi.Services
{
    /// <inheritdoc />
    public class ErrorService : IErrorService
    {
        private readonly ILogger<ErrorService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="ErrorService"/> class.
        /// </summary>
        /// <param name="logger"></param>
        public ErrorService(ILogger<ErrorService> logger)
        {
            _logger = logger;
        }

        /// <inheritdoc />
        public IResult HandleError(Exception excption)
        {
            switch (excption)
            {
                case BggException bggException:
                    return Results.Problem(title: bggException.Message, statusCode: bggException.HttpStatus);
                default:
                    return Results.StatusCode((int)HttpStatusCode.InternalServerError);
            }
        }
    }
}
