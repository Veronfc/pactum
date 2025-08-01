INSERT INTO payments (
    id,
    contract_id,
    amount,
    due_on,
    terms,
    status
) VALUES (
    @Id,
    @ContractId,
    @Amount,
    @DueOn,
    @Terms,
    @StatusString::paymentstatus
);