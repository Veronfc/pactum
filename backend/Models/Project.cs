using Humanizer;

namespace backend.Models
{
  public class Project
  {
    public Guid Id { get; set; }
    public Guid CreatorId { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public DateTime DraftedOn { get; set; }
    public DateTime? OpenedOn { get; set; }
    public decimal? StartingAmount { get; set; }
    public ProjectStatus Status { get; set; }
    public string StatusString => Status.ToString().Humanize().Underscore().ToLower();
  }

  public enum ProjectStatus
  {
    Draft,
    Open,
    InProgress,
    Completed,
    Cancelled
  }
}