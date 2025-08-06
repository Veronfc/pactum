namespace backend.Dto
{
    public record FilterOptions(
        string? ContractorId = null,
        DateTime? StartDate = null,
        DateTime? EndDate = null,
        string? TimeRange = null
    );
}