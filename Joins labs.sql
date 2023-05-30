use sakila;
/*  Lab | SQL Join  */  
/* 1:List the number of films per category.   */  
SELECT c.name AS category, COUNT(*) AS film_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

/* 2:Display the first and the last names, as well as the address, of each staff member.  */  
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a ON s.address_id = a.address_id;

/*  3:Display the total amount rung up by each staff member in August 2005.  */  
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_amount
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id, s.first_name, s.last_name;

/*  4:List all films and the number of actors who are listed for each film.  */  
SELECT f.title, COUNT(*) AS actor_count
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;
/*   5:Using the payment and the customer tables as well as the JOIN command, 
list the total amount paid by each customer. List the customers alphabetically by their last names. */  
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.last_name ASC;
/*    */  

/*Lab | SQL Joins on multiple tables    */  
/* 1: Write a query to display for each store its store ID, city, and country.  */  
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id;

/* 2:Write a query to display how much business, in dollars, each store brought in.  */  
SELECT s.store_id, SUM(p.amount) AS total_business
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;
/*  3:What is the average running time of films by category? */  
SELECT c.name AS category, AVG(f.length) AS average_running_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;
/* 4:Which film categories are longest? */  
SELECT c.name AS category, MAX(f.length) AS max_running_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY max_running_time DESC;
/*  5:Display the most frequently rented movies in descending order.  */  
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC;

/*  6: Display the most frequently rented movies in descending order. */  
SELECT c.name AS genre, SUM(p.amount) AS gross_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY gross_revenue DESC
LIMIT 5;
/*   7:Is "Academy Dinosaur" available for rent from Store 1? */  
SELECT COUNT(*) AS availability
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Academy Dinosaur' AND s.store_id = 1;



/*  Lab | SQL Self and cross join */  
/* 1:Get all pairs of actors that worked together.   */  
SELECT DISTINCT a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name
FROM actor a1
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id < a2.actor_id;

/* 2:Get all pairs of actors that worked together.   */  
SELECT DISTINCT c1.customer_id, c1.first_name, c1.last_name, c2.customer_id, c2.first_name, c2.last_name
FROM customer c1
JOIN rental r1 ON c1.customer_id = r1.customer_id
JOIN rental r2 ON r1.inventory_id = r2.inventory_id
JOIN customer c2 ON r2.customer_id = c2.customer_id
WHERE c1.customer_id < c2.customer_id
GROUP BY c1.customer_id, c2.customer_id
HAVING COUNT(*) > 3;

/* 3: Get all possible pairs of actors and films. */  
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM actor a
CROSS JOIN film f;
/*    */  

