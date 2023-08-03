using System.Net;

using BGC.SearchApi.Models.Exceptions;
using BGC.SearchApi.Services;

using Microsoft.AspNetCore.Http.HttpResults;

namespace BGC.SearchApi.UnitTests.Services
{
    public class ErrorServiceTests
    {
        private readonly Mock<ILogger<ErrorService>> _mockLogger;

        private readonly ErrorService errorService;

        public ErrorServiceTests()
        {
            _mockLogger = new Mock<ILogger<ErrorService>>();

            errorService = new ErrorService(_mockLogger.Object);
        }

        [Fact]
        public void HandleError_BggExcpetion_ReturnsProblemDetailsResult()
        {
            var bggException = new BggException(500, "Internal Error");

            var result = errorService.HandleError(bggException);

            result.Should().NotBeNull().And.BeOfType<ProblemHttpResult>();
            result.As<ProblemHttpResult>().ProblemDetails.Status.Should().Be(bggException.HttpStatus);
            result.As<ProblemHttpResult>().ProblemDetails.Title.Should().Be(bggException.Message);
        }

        [Fact]
        public void HandleError_GenericException_ReturnsInternalServerErrorResult()
        {
            var exception = new Exception("Generic stuff");

            var result = errorService.HandleError(exception);

            result.Should().NotBeNull().And.BeOfType<StatusCodeHttpResult>();
            result.As<StatusCodeHttpResult>().StatusCode.Should().Be((int)HttpStatusCode.InternalServerError);
        }
    }
}
