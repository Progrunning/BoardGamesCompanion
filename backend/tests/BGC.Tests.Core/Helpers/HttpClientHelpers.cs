using System.Net;

using Moq;
using Moq.Protected;

namespace BGC.Tests.Core.Helpers
{
    public static class HttpClientHelpers
    {
        public static HttpClient CreateClientReturningStatusCode(HttpStatusCode statusCode)
        {
            var _mockMessageHandler = new Mock<HttpMessageHandler>();
            _mockMessageHandler.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .Returns((HttpRequestMessage request, CancellationToken token) =>
                {
                    return Task.FromResult(new HttpResponseMessage(statusCode));
                })
                .Verifiable();

            return new HttpClient(_mockMessageHandler.Object);
        }

        public static HttpClient CreateClientReturningContent(StringContent content)
        {
            var _mockMessageHandler = new Mock<HttpMessageHandler>();
            _mockMessageHandler.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .Returns((HttpRequestMessage request, CancellationToken token) =>
                {
                    return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
                    {
                        Content = content
                    });
                })
                .Verifiable();

            return new HttpClient(_mockMessageHandler.Object);
        }

        public static HttpClient CreateExceptionThrowingClient(Exception exception)
        {
            var _mockMessageHandler = new Mock<HttpMessageHandler>();
            _mockMessageHandler.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ThrowsAsync(exception)
                .Verifiable();

            return new HttpClient(_mockMessageHandler.Object);
        }
    }
}
