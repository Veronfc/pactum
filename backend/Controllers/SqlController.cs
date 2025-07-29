using System.Threading.Tasks;
using backend.Models;
using backend.Services;
using Dapper;
using Humanizer;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace backend.Controllers
{
  [ApiController]
  [Route("sql")]
  public class SqlController(ISqlService sqlService, ISeedService seedService) : ControllerBase
  {
    private readonly ISqlService _sqlService = sqlService;
    private readonly ISeedService _seedService = seedService;
    private readonly string CONNECTION_STRING = Environment.GetEnvironmentVariable("CONNECTION_STRING") ?? throw new ArgumentNullException();

    [HttpGet("schema/init")]
    public async Task<IActionResult> InitializeSchema()
    {
      string sql = _sqlService.GetSql("Schema.init");

      using NpgsqlConnection connection = new(CONNECTION_STRING);

      try
      {
        await connection.ExecuteAsync(sql);
      }
      catch (Exception ex)
      {
        if (ex is PostgresException pgEx)
        {
          if (pgEx.SqlState == "42P07")
          {
            return Conflict(new { message = pgEx.MessageText });
          }

          return StatusCode(500, new { message = pgEx.ToString() });
        }

        return StatusCode(500, new { message = ex.Message });
      }

      return Created("", new { message = "Tables and types created." });
    }

    [HttpGet("schema/destroy")]
    public async Task<IActionResult> DestroySchema()
    {
      string sql = _sqlService.GetSql("Schema.destroy");

      using NpgsqlConnection connection = new(CONNECTION_STRING);

      try
      {
        await connection.ExecuteAsync(sql);
      }
      catch (Exception ex)
      {
        if (ex is PostgresException pgEx)
        {
          return StatusCode(500, new { message = pgEx.MessageText });
        }

        return StatusCode(500, new { message = ex.Message });
      }

      return NoContent();
    }

    [HttpGet("seed/{tableName}")]
    public async Task<IActionResult> SeedUsers(string tableName)
    {
      Type type = Type.GetType($"backend.Models.{tableName.Singularize().Pascalize()}", true)!;

      object seedData = _seedService.GetSeedData(type, tableName);

      string sql = _sqlService.GetSql($"Seed.{tableName}");

      using NpgsqlConnection connection = new(CONNECTION_STRING);

      try
      {
        await connection.ExecuteAsync(sql, seedData);
      }
      catch (Exception ex)
      {
        if (ex is PostgresException pgEx)
        {
          return StatusCode(418, new { message = pgEx.Data });
        }

        return StatusCode(500, new { message = ex.Message });
      }

      return NoContent();
    }
  }
}