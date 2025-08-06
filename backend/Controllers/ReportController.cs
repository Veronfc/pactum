using backend.Dto;
using backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers
{
    [ApiController]
    [Route("report")]
    public class ReportController(ISqlService sqlService) : ControllerBase
    {
        private readonly ISqlService _sqlService = sqlService;

        [HttpGet("bid-activity/{reportName}")]
        public async Task<IActionResult> GetBidActivityReport(string reportName, [FromBody] FilterOptions? filterOptions)
        {
            FilterOptions options = filterOptions ?? new FilterOptions();

            var result = await _sqlService.GetReport($"BidActivity.{reportName}", options);

            return result.Code == 200 ? Ok(result.Content) : StatusCode(result.Code, result.Content);
        }

    }
}
