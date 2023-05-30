/*Lab | SQL Subqueries   */  
/*  1: How many copies of the film Hunchback Impossible exist in the inventory system?*/  
SELECT COUNT(*) AS copy_count
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';
/*  2:List all films whose length is longer than the average of all the films. */  
SELECT *
FROM film
WHERE length > (SELECT AVG(length) FROM film);
/*  3:Use subqueries to display all actors who appear in the film Alone Trip.  */  
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip'));

/*  4:Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. */  
SELECT *
FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id = (SELECT category_id FROM category WHERE name = 'Family'));

/*  5:Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create
 a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.  */  
 SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')));

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

/*  6:Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
 First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred. */  
 SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.actor_id = (SELECT actor_id FROM (
    SELECT actor_id, COUNT(*) AS film_count
    FROM film_actor
    GROUP BY actor_id
    ORDER BY film_count DESC
    LIMIT 1
) AS subquery);

/*  7:Films rented by most profitable customer. 
You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments  */  
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE p.customer_id = (SELECT customer_id FROM (
    SELECT customer_id, SUM(amount) AS total_payments
    FROM payment
    GROUP BY customer_id
    ORDER BY total_payments DESC
    LIMIT 1
) AS subquery);

/*  8:Get the client_id and the total_amount_spent
 of those clients who spent more than the average of the total_amount spent by each client. */  
 SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount_spent) FROM (
    SELECT customer_id, SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
) AS subquery);

/*  Lab | SQL Advanced queries */  
/* List each pair of actors that have worked together.   */  
SELECT DISTINCT fa1.actor_id AS actor1_id, a1.first_name AS actor1_first_name, a1.last_name AS actor1_last_name,
                fa2.actor_id AS actor2_id, a2.first_name AS actor2_first_name, a2.last_name AS actor2_last_name
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id <> fa2.actor_id
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id;

/*  For each film, list actor that has acted in more films.  */  
SELECT f.film_id, f.title,
       a.actor_id, a.first_name, a.last_name
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE (fa.film_id, fa.actor_id) IN (
    SELECT film_id, actor_id
    FROM film_actor
    GROUP BY film_id, actor_id
    HAVING COUNT(*) = (
        SELECT MAX(actor_count)
        FROM (
            SELECT film_id, COUNT(*) AS actor_count
            FROM film_actor
            GROUP BY film_id
        ) AS subquery
    )
)
LIMIT 0, 1000;

/*  Lab | SQL Rolling calculations  */  
/*  Get number of monthly active customers. */  
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
       COUNT(DISTINCT customer_id) AS active_customers
FROM payment
GROUP BY month
ORDER BY month;

/*  Active users in the previous month.  */  
SELECT month,
       active_customers,
       LAG(active_customers) OVER (ORDER BY month) AS active_customers_previous_month
FROM (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
           COUNT(DISTINCT customer_id) AS active_customers
    FROM payment
    GROUP BY month
) AS monthly_active_customers
ORDER BY month;

/*Percentage change in the number of active customers.   */  
SELECT month,
       active_customers,
       active_customers_previous_month,
       ((active_customers - active_customers_previous_month) / active_customers_previous_month) * 100 AS percentage_change
FROM (
    SELECT month,
           active_customers,
           LAG(active_customers) OVER (ORDER BY month) AS active_customers_previous_month
    FROM (
        SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
               COUNT(DISTINCT customer_id) AS active_customers
        FROM payment
        GROUP BY month
    ) AS monthly_active_customers
) AS active_customers_comparison
ORDER BY month;

/*  Retained customers every month.  */  
SELECT month,
       active_customers,
       retained_customers
FROM (
    SELECT month,
           active_customers,
           (active_customers - LAG(active_customers) OVER (ORDER BY month)) AS retained_customers
    FROM (
        SELECT month,
               active_customers
        FROM (
            SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
                   COUNT(DISTINCT customer_id) AS active_customers
            FROM payment
            GROUP BY month
        ) AS monthly_active_customers
        ORDER BY month
    ) AS active_customers_comparison
) AS retained_customers_calculation
ORDER BY month;

/*    */  
/*    */  
/*    */  
