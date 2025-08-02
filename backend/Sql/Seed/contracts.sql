INSERT INTO contracts (
    id,
    contractor_id,
    bid_id,
    project_id,
    module_id,
    terms,
    agreed_value,
    offered_on,
    accepted_on,
    status
) VALUES (
    @Id,
    @ContractorId,
    @BidId,
    @ProjectId,
    @ModuleId,
    @Terms,
    @AgreedValue,
    @OfferedOn,
    @AcceptedOn,
    @StatusString::contractstatus
);