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
    public async Task<IActionResult> InitializeUsers()
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
            return Conflict(new { message = "'users' table already exists." });
          }

          return StatusCode(500, new { message = "A database error has occurred" });
        }
      }

      return Created("", new { message = "'users' table created." });
    }
  }
}