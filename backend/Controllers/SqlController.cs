using System.Threading.Tasks;
using backend.Services;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace backend.Controllers
{
  [ApiController]
  [Route("sql")]
  public class SqlController(ISqlService sqlService) : ControllerBase
  {
    private readonly ISqlService _sqlService = sqlService;
    private readonly string CONNECTION_STRING = Environment.GetEnvironmentVariable("CONNECTION_STRING") ?? throw new ArgumentNullException();

    [HttpGet("init")]
    public async Task<IActionResult> InitializeSchema()
    {
      string sql = _sqlService.GetSql("Schema.init.sql");

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

          return StatusCode(500, new { message = pgEx.MessageText });
        }

        return StatusCode(500, new { message = ex.Message });
      }

      return Created("", new { message = "Tables and types created." });
    }

    [HttpGet("destroy")]
    public async Task<IActionResult> DestroySchema()
    {
      string sql = _sqlService.GetSql("Schema.destroy.sql");

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
  }
}