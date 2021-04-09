/* Query1
(To understand more about the movies that families are watching, list each movie, the film category it is classified in, and the number of times it has been rented out). 
*/

SELECT DISTINCT
	f.title as film_title,
  c.name as category_name,
  count(rental_id) as rental_count
FROM
	film f
	JOIN inventory i ON f.film_id =i.film_id
	JOIN rental r ON r.inventory_id = i.inventory_id
	JOIN film_category fc ON f.film_id = fc.film_id
	JOIN category c ON c.category_id = fc.category_id
WHERE
	c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family' , 'Music')
GROUP BY
	1,
  	2
ORDER BY
	1 asc;


/* Query2
(To know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for).
*/

SELECT
	f.title as movie_title,
  c.name as category,
  f.rental_duration,
  NTILE(4) OVER (PARTITION BY f.title ORDER BY f.rental_duration desc) as standard_quartiles
FROM
	film f
	JOIN film_category fc ON f.film_id = fc.film_id
	JOIN category c ON c.category_id=fc.category_id
WHERE
	c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family' , 'Music');


/* Query3
(To know how the two stores compare in their count of rental orders during every month for all the years we have data for).
*/
WITH sub1 AS (
SELECT
 DATE_PART('month',r.rental_date) as Rental_month,
 DATE_PART('year',r.rental_date) as Rental_year,
 s.store_id as store_id,
 count(r.rental_id) as count_rentals
FROM
 	store s
	JOIN inventory I ON s.store_id=I.store_id
	JOIN rental r ON r.inventory_id=i.inventory_id
Group by
 1,
 2,
 3)

SELECT *
FROM sub1
ORDER BY
	4 desc;



/* Query4 
(To know the top 10 paying customers, and how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments).
*/

SELECT *
FROM (SELECT
   CONCAT(first_name,' ',last_name) as full_name,
   DATE_TRUNC('month', payment_date) as pay_month,
   SUM(amount) as pay_amount,
   count(payment_id) as count_permonthÊ
FROM
   customer c
   JOIN payment p ON p.customer_id=c.customer_id
GROUP BY
   1,
   2
ORDER BY
   4 desc,
   2 asc,
   3 desc
LIMIT 10
) t1;



