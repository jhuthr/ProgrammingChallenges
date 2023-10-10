# SQL Challenge

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

## Challenge Submit Instructions
1. Fork the repository
2. Answer the questions below in a single SQL file - e.g `answers.sql`
3. Provide Link to Forked Repository to PMG Talent Acquisition Team
4. Please provide a SQL statement for each question

## Questions

1. Write a query to get the sum of impressions by day.
2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?
3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?
5. In your opinion, which campaign was the most efficient, and why?

### Bonus Question
6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

## Solution

```sql
/* 1. sum of impressions by day */
SELECT sum(impressions), DATE_FORMAT(date, "%m-%d-%Y") as date_full FROM marketing_data GROUP BY date_full ORDER BY date_full ASC;

/* 2.a get the top three revenue-generating states in order of best to worst. */
SELECT sum(revenue) as revenue_sum, state FROM website_revenue GROUP BY state ORDER BY revenue_sum DESC limit 3;

/* 2.b How much revenue did the third best state generate? */
SELECT sum(revenue) as revenue_sum, state FROM website_revenue GROUP BY state ORDER BY revenue_sum DESC limit 1 offset 2;

/* 3. show total cost, impressions, clicks, and revenue of each campaign. */
SELECT sum(m.cost) as campaign_cost, sum(m.impressions) as campaign_impressions, sum(m.clicks) as campaign_clicks, sum(w.revenue) as campaign_revenue, c.name as campaign_name FROM marketing_data m, website_revenue w, campaign_info c WHERE m.campaign_id = w.campaign_id AND w.campaign_id = c.id GROUP BY c.name;

/* 4.a get the number of conversions of Campaign5 by state. */
SELECT sum(m.conversions) as conversions, m.geo as state FROM marketing_data m, campaign_info c WHERE c.name="Campaign5" AND c.id=m.campaign_id GROUP BY m.geo ORDER BY conversions DESC;

/* 4.b Which state generated the most conversions for this campaign? */
SELECT sum(m.conversions) as conversions, m.geo as state FROM marketing_data m, campaign_info c WHERE c.name="Campaign5" AND c.id=m.campaign_id GROUP BY m.geo ORDER BY conversions DESC LIMIT 1;

/* 5. Which campaign was the most efficient? */
SELECT sum(m.cost) as campaign_cost, sum(w.revenue) as campaign_revenue, sum(w.revenue)/sum(m.cost) as campaign_return_on_cost, sum(m.conversions)/sum(m.cost) as campaign_cost_per_conversion, sum(m.clicks)/sum(m.cost) as campaign_cost_per_click, sum(m.impressions)/sum(m.cost) as campaign_cost_per_impression, c.name FROM marketing_data m, website_revenue w, campaign_info c WHERE m.campaign_id=w.campaign_id AND w.campaign_id=c.id GROUP BY w.campaign_id;

/* 6. Best day of the week to run ads */
SELECT DATE_FORMAT(date, "%W") as day_of_week, sum(impressions) as day_of_week_impressions, sum(cost) as day_of_week_cost, sum(impressions)/sum(cost) as impressions_per_dollar FROM marketing_data GROUP BY day_of_week ORDER BY day_of_week_impressions DESC;
```

### Analysis:

For the 5th question, the efficiency of a campaign can be measured using metrics like `cost_per_click`, `cost_per_conversion`, and `cost_per_impression`. The lower these numbers, the better. The return on cost is also a significant metric that indicates the revenue return as a multiple of the cost. Therefore, the goal of the campaign should be considered when determining its efficiency.

For the bonus question, while Friday may have the highest number of impressions throughout the week, its cost in terms of `impressions_per_dollar` is also the highest. Conversely, Sunday might offer cheaper impressions, making it an ideal day to run ads and achieve similar results to costlier days by increasing the ad volume.


