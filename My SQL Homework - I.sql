
USE sakila;

# 1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`.
SELECT 
DISTINCT UPPER(CONCAT(first_name,' ', last_name))
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
SELECT 
	actor_id, 
    first_name, 
    last_name 
FROM actor 
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters `GEN`:
SELECT 
	actor_id, 
    first_name, 
    last_name 
FROM actor 
WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. 
# This time, order the rows by last name and first name, in that order:
SELECT 
	actor_id, 
    first_name, 
    last_name 
FROM actor  
WHERE last_name LIKE '%LI%' 
ORDER BY last_name, first_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following 
# countries: Afghanistan, Bangladesh, and China:
SELECT 
	country_id, 
    country 
FROM country 
WHERE country IN ( 'China', 'Afghanistan', 'Bangladesh');

# 3a. Add a `middle_name` column to the table `actor`. 
#Position it between `first_name` and `last_name`. Hint: you will need to specify the data type
ALTER TABLE 
	actor
ADD middle_name  VARCHAR(250) 
AFTER first_name;

# 3b. You realize that some of these actors have tremendously long last names. 
# Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE 
	`sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

# 3c. Now delete the `middle_name` column.
ALTER TABLE 
	actor
DROP COLUMN middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
	last_name, 
    COUNT(last_name) 
FROM actor 
GROUP BY last_name; 

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
SELECT 
	last_name, 
	COUNT(last_name) AS counted_lastname 
FROM actor
GROUP BY last_name 
HAVING counted_lastname > 1
ORDER BY counted_lastname DESC;

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
UPDATE 
	actor
SET first_name = CASE 
	WHEN first_name = 'HARPO' AND last_name = 'Williams' THEN 'GROUCHO'
	WHEN first_name = 'HARPO' AND last_name != 'Williams' THEN 'MOCHO GROUCHO'
END
WHERE first_name = 'HARPO';

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
		SUM(amount) AS 'total amount in august 2005' 
FROM staff s
JOIN payment p
    ON s.staff_id = p.staff_id
WHERE payment_date BETWEEN '2005-08-01 00:00' AND '2005-08-31 23:59:59'
GROUP BY s.staff_id;


# 6c. List each film and the number of actors who are listed for that film. 
# Use tables `film_actor` and `film`. Use inner join.
SELECT 
	title AS 'Film Title',
	COUNT(actor_id) AS 'Number of Actor Played'
FROM film f
JOIN film_actor fa
    ON f.film_id = fa.film_id
GROUP BY title
ORDER BY title;

# * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT 
	title AS 'Film Title',
	COUNT(inventory_id) AS 'How many coppies in inventory'
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY title;

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, 
# list the total paid by each customer. List the customers alphabetically by last name:
SELECT 	
	c.first_name, 
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
SELECT 
	f.title
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
SELECT 
	co.country AS 'Country of Customer', 
    CONCAT(first_name," ", last_name) AS Customer_Name,
    email AS 'Email Adress of Customer'
FROM country co
INNER JOIN city ci
	ON co.country_id = ci.country_id
INNER JOIN address ad
    ON ad.city_id = ci.city_id
INNER JOIN customer cu
    ON cu.address_id = ad.address_id
WHERE co.country = 'Canada'
ORDER BY cu.last_name;

#* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as famiy films.
SELECT 
	fi.title AS ' Film Title',
    ca.name AS 'Category of Movies'
FROM category ca
INNER JOIN film_category fc
	ON fc.category_id = ca.category_id
INNER JOIN film fi
    ON fi.film_id = fc.film_id
WHERE ca.name = 'Family'
ORDER BY fi.title;

# 7e. Display the most frequently rented movies in descending order.
SELECT 
	fi.title AS 'Film Name',
    COUNT(re.rental_id) AS ' How many times rented'
FROM rental re
INNER JOIN inventory inv
	ON re.inventory_id = inv.inventory_id
INNER JOIN film fi
	ON fi.film_id = inv.film_id
GROUP BY inv.film_id
ORDER BY COUNT(re.rental_id) DESC
LIMIT 10;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
	sto.store_id,
    SUM(pa.amount) AS 'Total Amount'
FROM store sto
INNER JOIN staff sta
	ON sto.store_id = sta.store_id
INNER JOIN payment pa
	ON pa.staff_id = sta.staff_id
GROUP BY sto.store_id;

#  7g. Write a query to display for each store its store ID, city, and country.
SELECT 
	sto.store_id AS ' Store ID',
    ci.city AS 'City',
    co.country AS 'Country'
FROM store sto
INNER JOIN address ad
	ON sto.address_id = ad.address_id
INNER JOIN city ci
	ON ad.city_id = ci.city_id
INNER JOIN country co
	ON co.country_id = ci.country_id
ORDER BY sto.store_id;

# * 7h. List the top five genres in gross revenue in descending order. 
# (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
	ca.name AS Genre,
    SUM(pa.amount) AS 'Gross Revenue'
FROM category ca
INNER JOIN film_category fc
	ON ca.category_id = fc.category_id
INNER JOIN inventory inv
	ON inv.film_id = fc.film_id
INNER JOIN rental re
	ON re.inventory_id = inv.inventory_id
INNER JOIN payment pa
	ON pa.rental_id = re.rental_id
GROUP BY ca.name
ORDER BY SUM(pa.amount) DESC
LIMIT 5;

# * 8a. In your new role as an executive, you would like to have an easy way of viewing the 
# Top five genres by gross revenue. Use the solution from the problem above to create a view. 
# If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_gross_revenues AS
SELECT 
	ca.name AS Genre,
    SUM(pa.amount) AS 'Gross Revenue'
FROM category ca
INNER JOIN film_category fc
	ON ca.category_id = fc.category_id
INNER JOIN inventory inv
	ON inv.film_id = fc.film_id
INNER JOIN rental re
	ON re.inventory_id = inv.inventory_id
INNER JOIN payment pa
	ON pa.rental_id = re.rental_id
GROUP BY ca.name
ORDER BY SUM(pa.amount) DESC
LIMIT 5;

#  8b. How would you display the view that you created in 8a?
SELECT * FROM top_gross_revenues;


# * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_gross_revenues;














