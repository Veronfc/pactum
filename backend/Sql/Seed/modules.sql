INSERT INTO modules (
    id,
    project_id,
    title,
    description,
    drafted_on,
    opened_on,
    starting_amount,
    status
) VALUES (
    @Id,
    @ProjectId,
    @Title,
    @Description,
    @DraftedOn,
    @OpenedOn,
    @StartingAmount,
    @StatusString::modulestatus
);