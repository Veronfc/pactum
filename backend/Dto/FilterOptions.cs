using backend.Models;

namespace backend.Dto
{
    public record FilterOptions(
        int? Limit = null,
        DateTime? StartDate = null,
        DateTime? EndDate = null,
        string? TimeRange = null,
        Guid? ContractorId = null,
        Guid? ProjectId = null,
        string? ProjectStatus = null
    );
}