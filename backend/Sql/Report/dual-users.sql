SELECT id, username
FROM users
WHERE EXISTS (SELECT 1 FROM projects WHERE users.id = projects.creator_id)
AND EXISTS (SELECT 1 FROM bids WHERE users.id = bids.bidder_id)
ORDER BY username;