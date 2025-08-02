INSERT INTO modules (
    id,
    project_id,
    title,
    description,
    starting_amount,
    status
) VALUES (
    @Id,
    @ProjectId,
    @Title,
    @Description,
    @StartingAmount,
    @StatusString::modulestatus
);