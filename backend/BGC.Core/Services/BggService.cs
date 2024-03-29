﻿using System.Xml.Serialization;

using BGC.Core.Models.Dtos.BoardGameGeek;
using BGC.Core.Models.Exceptions;
using BGC.Core.Services.Interfaces;

using Microsoft.Extensions.Logging;

namespace BGC.Core.Services;

/// <summary>
/// BGG API service.
/// </summary>
public class BggService : IBggService
{
    private const string SearchResultBoardGameType = "boardgame";

    private readonly ILogger<BggService> _logger;
    private readonly HttpClient _httpClient;

    /// <summary>
    /// Initializes a new instance of the <see cref="BggService"/> class.
    /// </summary>
    /// <param name="logger"></param>
    /// <param name="httpClient"></param>
    public BggService(ILogger<BggService> logger, HttpClient httpClient)
    {
        _logger = logger;
        _httpClient = httpClient;
    }

    /// <inheritdoc />
    public async Task<BoardGameSearchResponseDto> Search(string query, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(query))
        {
            return new BoardGameSearchResponseDto();
        }

        var requestUri = new Uri($"{_httpClient.BaseAddress}/search?query={query}&type={SearchResultBoardGameType}");
        var searchResponseStream = await _httpClient.GetStreamAsync(requestUri);

        var serializer = new XmlSerializer(typeof(BoardGameSearchResponseDto));
        var boardGamesDetailsResponse = (BoardGameSearchResponseDto?)serializer.Deserialize(searchResponseStream);
        if (boardGamesDetailsResponse is null)
        {
            throw new XmlParsingException($"Faield to parse search results for query {query}");
        }

        return boardGamesDetailsResponse;
    }

    /// <inheritdoc />
    public async Task<BoardGameDetailsDto> GetDetails(string boardGameId, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(boardGameId))
        {
            throw new ArgumentNullException(nameof(boardGameId));
        }

        var requestUri = new Uri($"{_httpClient.BaseAddress}/thing?id={boardGameId}&stats=1");
        var boardGameDetailsResponseStream = await _httpClient.GetStreamAsync(requestUri, cancellationToken);

        var serializer = new XmlSerializer(typeof(BoardGameDetailsResponseDto));
        var boardGamesDetailsResponse = (BoardGameDetailsResponseDto?)serializer.Deserialize(boardGameDetailsResponseStream);
        if (!(boardGamesDetailsResponse?.BoardGames?.Any() ?? false))
        {
            throw new XmlParsingException($"Faield to parse xml for {boardGameId}");
        }

        return boardGamesDetailsResponse.BoardGames.First();
    }
}
