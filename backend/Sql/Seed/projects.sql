INSERT INTO projects (
    id,
    creator_id,
    title,
    description,
    drafted_on,
    opened_on,
    starting_amount,
    status
) VALUES (
    @Id,
    @CreatorId,
    @Title,
    @Description,
    @DraftedOn,
    @OpenedOn,
    @StartingAmount,
    CAST(@StatusString AS projectstatus)
);