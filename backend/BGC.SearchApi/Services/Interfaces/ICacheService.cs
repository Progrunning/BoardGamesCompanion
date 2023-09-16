namespace BGC.SearchApi.Services.Interfaces
{
    /// <summary>
    /// Cache service.
    /// </summary>
    public interface ICacheService
    {
        /// <summary>
        /// Gets cache expiration in minutes.
        /// </summary>
        int CacheExpirationInMinutes { get; }

        /// <summary>
        /// Adds a board game to cache.
        /// </summary>
        /// <param name="boardGameIds"></param>
        /// <returns>A <see cref="Task"/> representing the asynchronous operation.</returns>
        Task Add(IEnumerable<string> boardGameIds);

        /// <summary>
        /// Updates already cached board game.
        /// </summary>
        /// <param name="boardGameIds"></param>
        /// <returns>A <see cref="Task"/> representing the asynchronous operation.</returns>
        Task Update(IEnumerable<string> boardGameIds);
    }
}
