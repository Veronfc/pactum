using System.Text.Json;
using backend.Services;
using Dapper;
using Humanizer;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace backend.Controllers
{
    [ApiController]
    [Route("report")]
    public class ReportController(ISqlService sqlService) : ControllerBase
    {
        private readonly ISqlService _sqlService = sqlService;
        private readonly string CONNECTION_STRING = Environment.GetEnvironmentVariable("CONNECTION_STRING") ?? throw new ArgumentNullException();

        [HttpGet("{reportName}")]
        public async Task<IActionResult> SeedUsers(string reportName)
        {
            string sql = _sqlService.GetSql($"Report.{reportName}");

            using NpgsqlConnection connection = new(CONNECTION_STRING);

            try
            {
                var rows = await connection.QueryAsync(sql, new { userId = "cd346ab3-ed56-427c-b0af-02de51e52bb9" });

                return Ok(JsonSerializer.Serialize(rows, new JsonSerializerOptions { WriteIndented = true }));
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
