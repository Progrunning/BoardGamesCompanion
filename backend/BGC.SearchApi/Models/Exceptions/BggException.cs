namespace BGC.SearchApi.Models.Exceptions
{
    public class BggException : Exception
    {
        public BggException(int httpStatus, string message)
            : base(message)
        {
            HttpStatus = httpStatus;
        }

        public int HttpStatus { get; }
    }
}
