/*
1.  sum of impressions by day
*/
SELECT sum(impressions), DATE_FORMAT(date, "%m-%d-%Y") as date_full FROM marketing_data GROUP BY date_full ORDER BY date_full ASC;


/*
2.a  get the top three revenue-generating states in order of best to worst. 
*/
SELECT sum(revenue) as revenue_sum, state FROM website_revenue GROUP BY state ORDER BY revenue_sum DESC limit 3;
/*
2.b  How much revenue did the third best state generate?
*/
SELECT sum(revenue) as revenue_sum, state FROM website_revenue GROUP BY state ORDER BY revenue_sum DESC limit 1 offset 2;


/*
3.  show total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
*/
SELECT sum(m.cost) as campaign_cost, sum(m.impressions) as campaign_impressions, sum(m.clicks) as campaign_clicks, sum(w.revenue) as campaign_revenue, c.name as campaign_name FROM marketing_data m, website_revenue w, campaign_info c WHERE m.campaign_id = w.campaign_id AND w.campaign_id = c.id GROUP BY c.name;


/*
4.a  get the number of conversions of Campaign5 by state. 
*/
SELECT sum(m.conversions) as conversions, m.geo as state FROM marketing_data m, campaign_info c WHERE c.name="Campaign5" AND c.id=m.campaign_id GROUP BY m.geo ORDER BY conversions DESC;
/*
4.b  Which state generated the most conversions for this campaign?
*/
SELECT sum(m.conversions) as conversions, m.geo as state FROM marketing_data m, campaign_info c WHERE c.name="Campaign5" AND c.id=m.campaign_id GROUP BY m.geo ORDER BY conversions DESC LIMIT 1;


/*
5.  In your opinion, which campaign was the most efficient, and why?
*/
SELECT sum(m.cost) as campaign_cost, sum(w.revenue) as campaign_revenue, sum(w.revenue)/sum(m.cost) as campaign_return_on_cost, sum(m.conversions)/sum(m.cost) as campaign_cost_per_conversion, sum(m.clicks)/sum(m.cost) as campaign_cost_per_click, sum(m.impressions)/sum(m.cost) as campaign_cost_per_impression, c.name FROM marketing_data m, website_revenue w, campaign_info c WHERE m.campaign_id=w.campaign_id AND w.campaign_id=c.id GROUP BY w.campaign_id;
/*
	Running the query shows the metrics of the campaign, like cost_per_click, and cost_per_conversion.  
	We want these numbers to be lower, so we can achieve a greater amount of 
	impressions, clicks, and conversions per dollar spent.  

	By this definition, the most effecient campaign is Campaign5, as it has the lowest
	cost_per_impression and ranks low in cost_per_click and cost_per_conversion.

	Another important metric is return_on_cost, which denotes the return (revenue) as a 
	multiple of the cost (higher is better).  Campaign5 had the lowest return_on_cost,
	so it is important to consider the goal of the campaign in finding the most 'effecient' one.

*/


/*
6.  showcase the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads
*/
SELECT DATE_FORMAT(date, "%W") as day_of_week, sum(impressions) as day_of_week_impressions, sum(cost) as day_of_week_cost, sum(impressions)/sum(cost) as impressions_per_dollar FROM marketing_data GROUP BY day_of_week ORDER BY day_of_week_impressions DESC;
/*
	Running this query shows that Friday carries the highest number of impressions
	throughout the week.  However, it also is the most costly in impressions_per_dollar.  

	Sunday has significantly less impressions, but the impressions are the cheapest.  
	Sunday is the best day of the week to run ads due to the cost.  To gain the same
	impressions as days like Friday, increase the volume of ads on the cheap days.  
*/