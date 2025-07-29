INSERT INTO contracts (
    id,
    contractor_id,
    project_id,
    bid_id,
    terms,
    agreed_value,
    offered_on,
    accepted_on,
    status
) VALUES (
    @Id,
    @ContractorId,
    @ProjectId,
    @BidId,
    @Terms,
    @AgreedValue,
    @OfferedOn,
    @AcceptedOn,
    CAST(@StatusString AS contractstatus)
);