/* EVALUACIÓN FINAL MÓDULO 02
*/
USE `sakila`;


/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
*/

SELECT DISTINCT `title`
	FROM `film`;
    
/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"
*/
SELECT `title` -- , `rating`
	FROM `film`
    WHERE `rating` = 'PG-13';

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
*/
-- uso de % para poder buscar la palabra en cualquier posición mediante LIKE
SELECT `title`, `description`
	FROM `film`
    WHERE `description` LIKE '%amazing%';
    
/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
*/

SELECT `title` -- , `length`
	FROM `film`
    WHERE `length` > 120;

/* 5. Recupera los nombres de todos los actores.
*/
-- Por que se lea mejor he realizado un CONCAT para juntar nombre y apellido en una nueva columna temporal llamada 'nombre'. También lo he ordenado alfabéticamente

SELECT CONCAT(`first_name`, ' ', `last_name`) AS `name`
	FROM `actor`
    ORDER BY `name`;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
*/

SELECT `first_name`, `last_name`
	FROM `actor`
    WHERE `last_name` IN ('GIBSON');
    
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `name`
	FROM `actor`
	WHERE `last_name` IN ('GIBSON')
    ORDER BY `name`;
    
/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
*/
-- Para mayor legibilidad realizo el CONCAT y ordeno el id.

SELECT CONCAT(`first_name`, ' ', `last_name`) AS `name`, `actor_id`
	FROM `actor`
    WHERE `actor_id` >= 10 AND `actor_id` <= 20
    ORDER BY `actor_id`;

/* 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
*/

SELECT `title` -- , `rating`
	FROM `film`
    WHERE `rating` NOT IN ('PG-13', 'R');

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.
*/
-- realizo un COUNT de título (aunque cualquier otro valor serviría, incluso todos con *) para realizar el conteo. Luego se agrupa con GROUP BY

SELECT `rating`, COUNT(`title`) AS `total_film`
	FROM `film`
    GROUP BY `rating`;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas
*/
-- Al ser dos tablas distintas, realizo un INNER JOIN para poder sacar el nombre y el apellido de los clientes, conectando mediante su ID.
-- Para encontrar el total de películar alquiladas, realizo un COUNT al que nombro 'total_rent' y lo agrupo mediante el ID del cliente
    
SELECT `r`.`customer_id`, `c`.`first_name`, `c`.`last_name`, COUNT(*) AS `total_rent`
	FROM `rental` AS `r` -- le pongo un alias para que sea más fácil y legible a la hora de usarlo
    INNER JOIN `customer` AS `c` 
		ON `r`.`customer_id` = `c`.`customer_id`
    GROUP BY `customer_id`;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
*/
-- realizo diferentes INNER JOIN para poder conectar las tablas entre sí para llegar hasta la tabla 'category'. 
-- se cuenta en este caso el ID del alquiler y lo agrupo mediante el ID de la categoría.
-- lo ordeno alfabéticamente por que sea más sencillo de leer

SELECT `ca`.`name`, COUNT(`r`.`rental_id`) AS `total_rent`
	FROM `rental` AS `r`
    INNER JOIN `inventory` AS `i`
		ON `r`.`inventory_id` = `i`.`inventory_id`
	INNER JOIN `film_category` AS `fc`
		ON `i`.`film_id` = `fc`.`film_id`
	INNER JOIN `category` AS `ca`
		ON `fc`.`category_id` = `ca`.`category_id`
	GROUP BY `ca`.`category_id`
    ORDER BY `ca`.`name`;
    
/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` 
y muestra la clasificación junto con el promedio de duración.
*/

SELECT `rating`, AVG(`length`) AS `length_avg`
	FROM `film`
    GROUP BY `rating`;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
*/

SELECT `a`.`first_name`, `a`.`last_name`
	FROM `actor` AS `a`
    INNER JOIN `film_actor` AS `fa`
		ON `a`.`actor_id` = `fa`.`actor_id`
	INNER JOIN `film` AS `f`
		ON `fa`.`film_id` = `f`.`film_id`
	WHERE `f`.`title` = 'Indian Love'
    ORDER BY `a`.`last_name`;
    
-- voy a realizar una segunda opción utilizando CTEs. Creo una tabla temporal llamada 'film' con el ID de la película 'Indian Love'

WITH `film` AS ( SELECT `film_id`
					FROM `film`
					WHERE `title` = 'Indian Love')

SELECT `a`.`first_name`, `a`.`last_name`
	FROM `actor` AS `a`
    INNER JOIN `film_actor` AS `fa`
		ON `a`.`actor_id` = `fa`.`actor_id`
	WHERE `fa`.`film_id` IN (SELECT * -- aquí también podría poner 'film_id' pero como sólo hay una columna puedo poder el asterisco ya que es lo que busco
								FROM `film`)
	ORDER BY `a`.`last_name`;


/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
*/

SELECT `title` -- , `description`
	FROM `film`
    WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%';

/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.
*/

SELECT *
FROM `actor`
WHERE `actor_id` NOT IN (SELECT `actor_id` -- selecciono la columa actor_id. Así en la subconsulta tenemos todos los IDs que están en la tabla film_actor
							FROM `film_actor`); 
                            
-- El resultado de la consulta da NULL ya que parece ser que todos los IDs de actores se encuentran la tabla film_actor


/* 16. 
*/

/* 17. 
*/

/* 18. 
*/

/* 19. 
*/

/* 20. 
*/
