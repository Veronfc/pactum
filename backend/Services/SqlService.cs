using System.Reflection;
using System.Text.Json;
using backend.Dto;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace backend.Services
{
  public interface ISqlService
  {
    string GetSql(string name);
    Task<GetReportResult> GetReport(string name, FilterOptions options);
  }

  public class SqlService : ISqlService
  {
    private readonly Assembly _assembly;
    private readonly string CONNECTION_STRING = Environment.GetEnvironmentVariable("CONNECTION_STRING") ?? throw new ArgumentNullException();

    public SqlService()
    {
      _assembly = Assembly.GetExecutingAssembly();
    }

    public string GetSql(string name)
    {
      string resourceName = $"backend.Sql.{name}.sql";

      using Stream stream = _assembly.GetManifestResourceStream(resourceName) ?? throw new FileNotFoundException($"Embedded resource {resourceName} not found");

      using StreamReader reader = new(stream);

      return reader.ReadToEnd();
    }

    public async Task<GetReportResult> GetReport(string name, FilterOptions options)
    {
      string sql = GetSql($"Reports.{name}");

      using NpgsqlConnection connection = new(CONNECTION_STRING);

      try
      {
        var rows = await connection.QueryAsync(sql, options);

        return new GetReportResult(200, JsonSerializer.Serialize(rows, new JsonSerializerOptions { WriteIndented = true }));
      }
      catch (Exception ex)
      {
        if (ex is PostgresException pgEx)
        {
          return new GetReportResult(418, JsonSerializer.Serialize(pgEx.Data, new JsonSerializerOptions { WriteIndented = true }));
        }

        return new GetReportResult(500, ex.Message);
      }
    }
  }

  public record GetReportResult(int Code, string Content);
}