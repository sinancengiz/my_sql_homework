

use sakila;

# 1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`.
SELECT 
DISTINCT upper(concat(first_name ," ", last_name)) 
AS 'Actor Name' 
FROM actor 
ORDER BY first_name ASC;

#1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column `Actor Name`.
SELECT 
DISTINCT upper(concat(first_name ," ", last_name)) 
AS 'Actor_Name' 
FROM actor 
ORDER BY first_name ASC;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe.
# " What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. 
# This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name 
FROM actor  
WHERE last_name LIKE '%LI%' 
ORDER BY last_name, first_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following 
# countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country = "China" OR country = "Afghanistan" OR country ="Bangladesh";

# 3a. Add a `middle_name` column to the table `actor`. 
#Position it between `first_name` and `last_name`. Hint: you will need to specify the data type
ALTER TABLE actor
ADD middle_name  VARCHAR(250) AFTER first_name;

# 3b. You realize that some of these actors have tremendously long last names. 
# Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

# 3c. Now delete the `middle_name` column.
ALTER TABLE actor
DROP COLUMN middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) 
FROM actor 
GROUP BY last_name; 

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors



#* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table 
# as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. 
# Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'Williams';

#* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
#It turns out that `GROUCHO` was the correct name after all! In a single query, 
# if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
# Otherwise, change the first name to `MUCHO GROUCHO`,
#  as that is exactly what the actor will be with the grievous error.
#  BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, 
# HOWEVER! (Hint: update the record using a unique identifier.)





# 5a. You cannot locate the schema of the `address` table. 
# Which query would you use to re-create it?
CREATE TABLE address (
	address_id SMALLINT(5) AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city_id SMALLINT(5) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    location GEOMETRY NOT NULL,
    last_update TIMESTAMP NOT NULL
);

#6a. Use `JOIN` to display the first and last names, as well as the address, 
# of each staff member. Use the tables `staff` and `address`:
SELECT first_name, 
		last_name, 
        CONCAT( address, " " , district) AS Address  
FROM staff s
JOIN address a
    ON a.address_id = s.address_id;
    
# * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005
# Use tables `staff` and `payment`. 
    
SELECT first_name, 
		last_name,
		SUM(amount) as 'total amount in august 2005' 
FROM staff s
JOIN payment p
    ON s.staff_id = p.staff_id
Where payment_date between '2005-08-01 00:00' AND '2055-08-31 23:59:59'
GROUP BY s.staff_id;


# 6c. List each film and the number of actors who are listed for that film. 
# Use tables `film_actor` and `film`. Use inner join.
SELECT title as 'Film Title',
	   count(actor_id) as 'Number of Actor Played'
       
FROM film f
JOIN film_actor fa
    ON f.film_id = fa.film_id
group by title
order by title;

# * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title as 'Film Title',
	   count(inventory_id) as 'How many coppies in inventory'
       
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
Where title = 'Hunchback Impossible'
group by title
order by title;

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, 
# list the total paid by each customer. List the customers alphabetically by last name:
SELECT 	c.first_name, 
		c.last_name,
        SUM(amount) AS 'Total Amount Paid'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity.
# Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT f.title
FROM film f
JOIN language l
	ON f.language_id = l.language_id
WHERE (title LIKE 'K%' OR title LIKE 'Q%') AND l.name = 'English';

# * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT 
	CONCAT(a.first_name,' ', a.last_name) 
    AS 'Actors in Alone Trip' 
FROM film f
JOIN film_actor fa
	ON f.film_id = fa.film_id
JOIN actor a
	ON fa.actor_id = a.actor_id  
WHERE f.title = 'Alone Trip';

# * 7c. You want to run an email marketing campaign in Canada, 
# for which you will need the names and email addresses of all Canadian customers. 
# Use joins to retrieve this information.




























