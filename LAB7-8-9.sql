USE sakila;
/* LAB 7   */  
/*In the table actor, which are the actors whose last names are not repeated? For example if you would sort the 
data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
These three actors have the same last name. 
So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor 
"Angelina Astaire", hence we would want this in our output list.    */  

SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;



/* Which last names appear more than once?
 We would use the same logic as in the previous question but this time we want 
 to include the last names of the actors where the last name was present more than once   */  
 SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

 
/*  Using the rental table, find out how many rentals were processed by each employee.   */  
SELECT staff_id, COUNT(*) AS rental_count
FROM rental
GROUP BY staff_id;

/*  Using the film table, find out how many films were released each year.  */  
SELECT EXTRACT(YEAR FROM release_year) AS year, COUNT(*) AS film_count
FROM film
GROUP BY year;

/*  Using the film table, find out for each rating how many films were there.  */  
SELECT rating, COUNT(*) AS film_count
FROM film
GROUP BY rating;

/*What is the mean length of the film for each rating type. Round off the average lengths to two decimal places    */  
SELECT rating, ROUND(AVG(length), 2) AS avg_length
FROM film
GROUP BY rating;

/*  Which kind of movies (rating) have a mean duration of more than two hours?   */  
SELECT rating
FROM film
GROUP BY rating
HAVING AVG(length) > 120;


/*  Lab 8   */  

/*   Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output. */  
SELECT title, length, RANK() OVER (ORDER BY length DESC) AS `rank`
FROM film
WHERE length IS NOT NULL AND length > 0;



/*Rank films by length within the rating category (filter out the rows with nulls or zeros 
in length column). In your output, only select the columns title, length, rating and rank. */  
SELECT title, length, rating, RANK() OVER (PARTITION BY rating ORDER BY length DESC) AS `rank`
FROM film
WHERE length IS NOT NULL AND length > 0;

    
/*  How many films are there for each of the categories in the category table? Hint: Use appropriate join between the tables "category" and "film_category".  */  
SELECT c.name AS category, COUNT(*) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;


/*  Which actor has appeared in the most films? Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.  */  
SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;

/* Which is the most active customer (the customer that has rented the most number of films)? 
Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.   */  
SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC
LIMIT 1;

/*  LAB 9  */  

/*Create a table rentals_may to store the data from rental table with information for the month of May.    */
CREATE TABLE rentals_may AS
SELECT *
FROM rental
WHERE MONTH(rental_date) = 5;
  
/* Insert values in the table rentals_may using the table rental, filtering values only for the month of May.   */  
INSERT INTO rentals_may
SELECT *
FROM rental
WHERE MONTH(rental_date) = 5;

/*  Create a table rentals_june to store the data from rental table with information for the month of June.  */  
CREATE TABLE rentals_june AS
SELECT *
FROM rental
WHERE MONTH(rental_date) = 6;

/* Insert values in the table rentals_june using the table rental, filtering values only for the month of June.   */  
INSERT INTO rentals_june
SELECT *
FROM rental
WHERE MONTH(rental_date) = 6;

/*  Check the number of rentals for each customer for May.  */  
SELECT customer_id, COUNT(*) AS rental_count
FROM rentals_may
GROUP BY customer_id;

/* Check the number of rentals for each customer for June.   */  
SELECT customer_id, COUNT(*) AS rental_count
FROM rentals_june
GROUP BY customer_id;


/*    */  

/*    */  

/*    */  
/*    */  

/*    */  
/*    */  
/*    */  
/*    */  
/*    */  
/*    */  

/*    */  

/*    */  

/*    */  
/*    */  