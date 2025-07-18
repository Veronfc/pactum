using System.Data.SqlTypes;

namespace backend.Models
{
  public class Contract
  {
    public Guid Id { get; set; }
    public Guid ContractorId { get; set; }
    public Guid ProjectId { get; set; }
    public Guid BidId { get; set; }
    public string Terms { get; set; }
    public decimal Value { get; set; }
    public DateTime OfferedOn { get; set; }
    public DateTime? AcceptedOn { get; set; }
    public ContractStatus Status { get; set; }
  }

  public enum ContractStatus
  {
    OFFERED,
    ACTIVE,
    DELIVERED,
    APPROVED,
    DISPUTED,
    CANCELLED
  }
}