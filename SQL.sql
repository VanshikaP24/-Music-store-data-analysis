/* who is the senior most employee based on job title? */
select * from employee
order by levels desc
limit 1;

/* which countries have the most invoices? */
select count(*) as c, billing_country
from invoice 
group by billing_country
order by c desc;

/*what are top 3 values of total invoice? */
select total from invoice
order by total desc
limit 3;

/* which city has the best customers?we would like to throw a promotional music festival in city we made the most money.
Write a query that returns one city that has highest sum of invoice totals.Return both city name and sum of all invoice totals. */
select sum(total) as invoice_total, billing_city 
from invoice
group by billing_city
order by invoice_total desc;

/* who is the best customer?The customer who has spent most money will be declared the best customer.Write a query
that returns the personwho has spent the most money. */
select customer.customer_id , sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;

/*write a query to return the email,first name,last name & genre of all rock music listeners. Return your list ordered alphabetically 
by email starting with A */
select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
    select track_id from track
    join genre on track.genre_id = genre.genre_id
    where genre.name like 'Rock'
)
order by email;

 
 /*Return all the track names that have a song length longer than  average song length. Return the Name and Milliseconds for
 each track. Order by the song length with the longest songs listed first. */
 select name,milliseconds
 from track
 where milliseconds > (
 select avg(milliseconds) as avg_track_length
 from track)
 order by milliseconds desc;
 
/* We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

/* Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;


