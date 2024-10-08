-- noinspection SqlNoDataSourceInspectionForFile
-- noinspection SqlResolveForFile
CREATE SINK nexmark_q21_temporal_filter AS
SELECT auction,
       bidder,
       price,
       channel,
       CASE
           WHEN LOWER(channel) = 'apple' THEN '0'
           WHEN LOWER(channel) = 'google' THEN '1'
           WHEN LOWER(channel) = 'facebook' THEN '2'
           WHEN LOWER(channel) = 'baidu' THEN '3'
           ELSE (regexp_match(url, '(&|^)channel_id=([^&]*)'))[2]
           END
           AS channel_id
FROM bid_filtered
WHERE (regexp_match(url, '(&|^)channel_id=([^&]*)'))[2] is not null
   or LOWER(channel) in ('apple', 'google', 'facebook', 'baidu')
WITH ( connector = 'blackhole', type = 'append-only', force_append_only = 'true');
