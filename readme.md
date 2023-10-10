# SQL Challenge Solution - Justin Huther
Oct 10, 2023

The database contains three tables: `marketing_performance`, `website_revenue`, and `campaign_info`. 

## Table Definitions

```sql
create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);

create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
);
```
## Questions

1. Write a query to get the sum of impressions by day.
2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?
3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?
5. In your opinion, which campaign was the most efficient, and why?

### Bonus Question
6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

## Justin Huther Solution
Oct 10, 2023
```sql
/* 
1. Sum of impressions by day 
*/
SELECT 
    SUM(impressions) AS total_impressions,
    DATE_FORMAT(date, "%m-%d-%Y") AS date_full 
FROM 
    marketing_data 
GROUP BY 
    date_full 
ORDER BY 
    date_full ASC;

/* 
2.a Get the top three revenue-generating states in order of best to worst 
*/
SELECT 
    SUM(revenue) AS revenue_sum, 
    state 
FROM 
    website_revenue 
GROUP BY 
    state 
ORDER BY 
    revenue_sum DESC 
LIMIT 
    3;

/* 
2.b How much revenue did the third best state generate? 
*/
SELECT 
    SUM(revenue) AS revenue_sum, 
    state 
FROM 
    website_revenue 
GROUP BY 
    state 
ORDER BY 
    revenue_sum DESC 
LIMIT 1 
OFFSET 2;

/* 
3. Show total cost, impressions, clicks, and revenue of each campaign. Include campaign name in the output. 
*/
SELECT 
    SUM(m.cost) AS campaign_cost, 
    SUM(m.impressions) AS campaign_impressions, 
    SUM(m.clicks) AS campaign_clicks, 
    SUM(w.revenue) AS campaign_revenue, 
    c.name AS campaign_name 
FROM 
    marketing_data m 
JOIN 
    website_revenue w ON m.campaign_id = w.campaign_id 
JOIN 
    campaign_info c ON w.campaign_id = c.id 
GROUP BY 
    c.name;

/* 
4.a Get the number of conversions of Campaign5 by state 
*/
SELECT 
    SUM(m.conversions) AS conversions, 
    m.geo AS state 
FROM 
    marketing_data m 
JOIN 
    campaign_info c ON c.id = m.campaign_id 
WHERE 
    c.name = "Campaign5" 
GROUP BY 
    m.geo 
ORDER BY 
    conversions DESC;

/* 
4.b Which state generated the most conversions for this campaign? 
*/
SELECT 
    SUM(m.conversions) AS conversions, 
    m.geo AS state 
FROM 
    marketing_data m 
JOIN 
    campaign_info c ON c.id = m.campaign_id 
WHERE 
    c.name = "Campaign5" 
GROUP BY 
    m.geo 
ORDER BY 
    conversions DESC 
LIMIT 1;

/* 
5. In your opinion, which campaign was the most efficient, and why? 
*/
SELECT 
    SUM(m.cost) AS campaign_cost, 
    SUM(w.revenue) AS campaign_revenue, 
    (SUM(w.revenue) / SUM(m.cost)) AS campaign_return_on_cost, 
    (SUM(m.conversions) / SUM(m.cost)) AS campaign_cost_per_conversion, 
    (SUM(m.clicks) / SUM(m.cost)) AS campaign_cost_per_click, 
    (SUM(m.impressions) / SUM(m.cost)) AS campaign_cost_per_impression, 
    c.name 
FROM 
    marketing_data m 
JOIN 
    website_revenue w ON m.campaign_id = w.campaign_id 
JOIN 
    campaign_info c ON w.campaign_id = c.id 
GROUP BY 
    w.campaign_id;

/* 
6. Showcase the best day of the week to run ads 
*/
SELECT 
    DATE_FORMAT(date, "%W") AS day_of_week, 
    SUM(impressions) AS day_of_week_impressions, 
    SUM(cost) AS day_of_week_cost, 
    (SUM(impressions) / SUM(cost)) AS impressions_per_dollar 
FROM 
    marketing_data 
GROUP BY 
    day_of_week 
ORDER BY 
    day_of_week_impressions DESC;
```

### Analysis:

For the 5th question, the efficiency of a campaign can be measured using metrics like `cost_per_click`, `cost_per_conversion`, and `cost_per_impression`. The lower these numbers, the better. The return on cost is also a significant metric that indicates the revenue return as a multiple of the cost. Therefore, the goal of the campaign should be considered when determining its efficiency.

For the bonus question, while Friday may have the highest number of impressions throughout the week, its cost in terms of `impressions_per_dollar` is also the highest. Conversely, Sunday might offer cheaper impressions, making it an ideal day to run ads and achieve similar results to costlier days by increasing the ad volume.


