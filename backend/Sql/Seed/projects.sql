INSERT INTO projects (
    id,
    creator_id,
    title,
    description,
    is_modular,
    drafted_on,
    opened_on,
    starting_amount,
    status
) VALUES (
    @Id,
    @CreatorId,
    @Title,
    @Description,
    @IsModular,
    @DraftedOn,
    @OpenedOn,
    @StartingAmount,
    @StatusString::projectstatus
);