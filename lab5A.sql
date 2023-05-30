USE sakila;
/* Drop column picture from staff.    */
ALTER TABLE staff
DROP COLUMN picture;
/* A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.    */
INSERT INTO staff (staff_id, first_name, last_name, address_id, email, store_id, active, username, password)
VALUES (10, 'Tammy', 'Sanders', 1, 'tammy.sanders@example.com', 1, 1, 'tsanders', 'password');

/*  
Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
You can use current date for the rental_date column in the rental table. 
Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. 
For eg., you would notice that you need customer_id information as well. To get that you can use the following query:
 
Use similar method to get inventory_id, film_id, and staff_id.    */    
SELECT customer_id FROM sakila.customer
WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER';
			   
SELECT inventory_id FROM sakila.inventory
WHERE film_id = (
SELECT film_id FROM sakila.film
WHERE title = 'ACADEMY DINOSAUR') 
AND store_id = 1 AND status = 'Available';

SELECT staff_id FROM sakila.staff
WHERE first_name = 'MIKE' AND last_name = 'HILLYER';


   



/* Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, 
and the date for the users that would be deleted. Follow these steps:    */  
/*  Check if there are any non-active users   */  
/*   Create a table backup table as suggested  */  
/*   Insert the non active users in the table backup table  */  
/*   Delete the non active users from the table customer  */ 
SELECT * FROM sakila.customer
WHERE active = 0;
CREATE TABLE deleted_users (
    customer_id INT,
    email VARCHAR(50),
    delete_date DATE
);
INSERT INTO deleted_users (customer_id, email, delete_date)
SELECT customer_id, email, NOW() FROM sakila.customer
WHERE active = 0;
DELETE FROM sakila.customer
WHERE active = 0;



