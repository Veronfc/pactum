INSERT INTO bids (
    id,
    project_id,
    bidder_id,
    amount,
    submitted_on,
    status
) VALUES (
    @Id,
    @ProjectId,
    @BidderId,
    @Amount,
    @SubmittedOn,
    CAST(@StatusString AS bidstatus)
);