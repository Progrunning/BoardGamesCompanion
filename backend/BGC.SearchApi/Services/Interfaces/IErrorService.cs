namespace BGC.SearchApi.Services.Interfaces
{
    public interface IErrorService
    {
        IResult HandleError(Exception excption);
    }
}
