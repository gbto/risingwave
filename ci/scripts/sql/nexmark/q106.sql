-- noinspection SqlNoDataSourceInspectionForFile
-- noinspection SqlResolveForFile
CREATE SINK nexmark_q106
AS
SELECT
    MIN(final) AS min_final
FROM
    (
        SELECT
            auction.id,
            MAX(price) AS final
        FROM
            auction,
            bid
        WHERE
            bid.auction = auction.id
            AND bid.date_time BETWEEN auction.date_time AND auction.expires
        GROUP BY
            auction.id
    )
WITH ( connector = 'blackhole', type = 'append-only', force_append_only = 'true');
