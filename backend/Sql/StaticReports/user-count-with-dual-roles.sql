SELECT
    count(*) AS users_with_dual_roles_count
FROM users
WHERE EXISTS (SELECT 1 FROM projects WHERE projects.creator_id = users.id)
AND EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = users.id)