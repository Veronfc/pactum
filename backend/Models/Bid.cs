namespace backend.Models
{
  public class Bid
  {
    public Guid Id { get; set; }
    public Guid BidderId { get; set; }
    public Guid ProjectId { get; set; }
    public Guid ModuleId { get; set; }
    public decimal Amount { get; set; }
    public DateTime SubmittedOn { get; set; }
    public BidStatus Status { get; set; }
    public string StatusString => Status.ToString().ToLower();
  }

  public enum BidStatus
  {
    Submitted,
    Withdrawn,
    Accepted,
    Rejected
  }
}