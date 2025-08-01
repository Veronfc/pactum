INSERT INTO bids (
    id,
    bidder_id,
    project_id,
    module_id,
    amount,
    submitted_on,
    status
) VALUES (
    @Id,
    @BidderId,
    @ProjectId,
    @ModuleId,
    @Amount,
    @SubmittedOn,
    @StatusString::bidstatus
);