using Humanizer;

namespace backend.Models
{
  public class Payment
  {
    public Guid Id { get; set; }
    public Guid ContractId { get; set; }
    public decimal Amount { get; set; }
    public DateTime DueOn { get; set; }
    public string Terms { get; set; }
    public PaymentStatus Status { get; set; }
    public string StatusString => Status.ToString().Humanize().Underscore().ToLower();
  }
  public enum PaymentStatus
  {
    Scheduled,
    Due,
    Processing,
    Completed,
    Failed,
    Refunded
  }
}