using Humanizer;

namespace backend.Models
{
    public class Module
    {
        public Guid Id { get; set; }
        public Guid ProjectId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DraftedOn { get; set; }
        public DateTime? OpenedOn { get; set; }
        public decimal? StartingAmount { get; set; }
        public ModuleStatus Status { get; set; }
        public string StatusString => Status.ToString().Humanize().Underscore().ToLower();
    }

  public enum ModuleStatus
  {
    Draft,
    Open,
    InProgress,
    Completed,
    Cancelled
  }
}