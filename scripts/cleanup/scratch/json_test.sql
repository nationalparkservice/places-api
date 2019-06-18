/*
// 2636, 2609
SELECT 
A.tags->>'sac_scale' as "1",
A.tags->>'operator' as "2",
A.tags->>'incline' as "3",
A.tags->>'motor_vehicle' as "4",
A.tags->>'access'as "5",
A.tags->>'smoking'as "6",
A.tags->>'canoe' as "7",
A.tags->>'snowmobile'as"8",
A.tags->>'population'as"9"
FROM (SELECT tags::json FROM nps_render_point) A;
*/


SELECT
(tags::json)->>'sac_scale' as "1",
(tags::json)->>'operator' as "2",
(tags::json)->>'incline' as "3",
(tags::json)->>'motor_vehicle' as "4",
(tags::json)->>'access'as "5",
(tags::json)->>'smoking'as "6",
(tags::json)->>'canoe' as "7",
(tags::json)->>'snowmobile'as"8",
(tags::json)->>'population'as"9"
FROM nps_render_point A;
