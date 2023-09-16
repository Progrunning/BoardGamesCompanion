namespace BGC.SearchApi.Services.Interfaces
{
    /// <summary>
    /// Service that handles API errors.
    /// </summary>
    public interface IErrorService
    {
        /// <summary>
        /// Handle errors, by transforming them into <see cref="IResult"/>.
        /// </summary>
        /// <param name="excption"></param>
        /// <returns><see cref="IResult"/>.</returns>
        IResult HandleError(Exception excption);
    }
}
