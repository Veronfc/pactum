SELECT
    count(*) AS users_with_dual_roles_count
FROM users
INNER JOIN projects
ON users.id = projects.creator_id
INNER JOIN bids
ON projects.creator_id = bids.bidder_id