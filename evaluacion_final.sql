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
-- uso de % antes y después de 'amazing' para segurar que la palabra puede estar en cualquier posición dentro de la cadena

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
-- En este caso usar IN y LIKE da el mismo resultado, pero en otros casos puede ser diferente. Con IN se buscarían las coincidencias exactas
-- En el caso de LIKE, al crear el patrón serái cualquier apellido que contenga 'GIBSON'

SELECT `first_name`, `last_name`
	FROM `actor`
    WHERE `last_name` IN ('GIBSON');
    
SELECT `first_name`, `last_name`
	FROM `actor`
    WHERE `last_name` LIKE '%GIBSON%';
    
 -- opción del nombre con CONCAT:
 
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `name`
	FROM `actor`
	WHERE `last_name` LIKE '%GIBSON%';
    
/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
*/
-- Para mayor legibilidad realizo el CONCAT y ordeno el id.

SELECT CONCAT(`first_name`, ' ', `last_name`) AS `name`, `actor_id`
	FROM `actor`
    WHERE `actor_id` >= 10 AND `actor_id` <= 20
    ORDER BY `actor_id`;

/* 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
*/
-- uso de NOT IN para excluir la condición

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
-- utilizo INNER JOIN entre las tablas 'rental' y 'customer' para combinar la información de los clientes mediante el ID.
-- uso de la función COUNT para contar el número de alquileres por cliente y mediante GROUP BY se agrupa por ID del cliente
    
SELECT `r`.`customer_id`, `c`.`first_name`, `c`.`last_name`, COUNT(*) AS `total_rent`
	FROM `rental` AS `r` -- le pongo un alias para que sea más fácil y legible a la hora de usarlo
    INNER JOIN `customer` AS `c` 
		ON `r`.`customer_id` = `c`.`customer_id`
    GROUP BY `customer_id`;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
*/

-- realizo varios INNER JOIN para conectar las tablas rental, inventory, film_category y category para llagar a esta última 
-- mediante la función COUNT cuento el número de alquileres por categoría y se agrupa mediante GROUP BY por el ID de la categoría
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
-- mediante el uso de un INNER JOIN combino las tablas actor, film_actor y film
-- filtro usando la clausula WHERE con la condición de que coincida con el título 

SELECT `a`.`first_name`, `a`.`last_name`
	FROM `actor` AS `a`
    INNER JOIN `film_actor` AS `fa`
		ON `a`.`actor_id` = `fa`.`actor_id`
	INNER JOIN `film` AS `f`
		ON `fa`.`film_id` = `f`.`film_id`
	WHERE `f`.`title` = 'Indian Love'
    ORDER BY `a`.`last_name`;
    
-- también puedo obtener el resultado usando una CTE que me busca el ID de la película 'Indian Love'
-- a continuación introduzco la CTE en la cláusula WHERE

WITH `film` AS ( SELECT `film_id`
					FROM `film`
					WHERE `title` = 'Indian Love')

SELECT `a`.`first_name`, `a`.`last_name`
	FROM `actor` AS `a`
    INNER JOIN `film_actor` AS `fa`
		ON `a`.`actor_id` = `fa`.`actor_id`
	WHERE `fa`.`film_id` IN (SELECT * -- aquí también podría poner 'film_id' pero como sólo hay una columna puedo poder el asterisco
								FROM `film`)
	ORDER BY `a`.`last_name`;


/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
*/

SELECT `title` -- , `description`
	FROM `film`
    WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%';

/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.
*/
-- uso de una subconsulta para poder obtener los IDs de los actores que se encuentran en la tabla film_actor
-- mediante el uso de NOT IN excluyo esos resultados para optener aquellos que no se encuentran en la tabla
-- el resultado de la consulta da NULL ya que parece ser que todos los IDs de actores se encuentran la tabla film_actor

SELECT *
FROM `actor`
WHERE `actor_id` NOT IN (SELECT `actor_id` -- selecciono la columa actor_id. Así en la subconsulta tenemos todos los IDs que están en la tabla film_actor
							FROM `film_actor`); 
                            

/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
*/

SELECT `title`, `release_year`
	FROM `film`
    WHERE `release_year` >= 2005 AND `release_year` <= 2010;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
*/
-- uso de dos INNER JOIN para conectar las tablas film, film_category y category
-- se filtra para que se seleccione aquellas películas en la categoría 'Family'

SELECT `f`.`title` -- , `c`.`name`
	FROM `film` AS `f`
    INNER JOIN `film_category` AS `fc`
		ON `f`.`film_id` = `fc`.`film_id`
	INNER JOIN `category` AS `c`
		ON `fc`.`category_id` = `c`.`category_id`
	WHERE `c`.`name` = 'Family';

/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
*/
-- uso de un INNER JOIN entre las tablas actor y film_actor mediante actor_id. Lo agrupo mediante el ID también.
-- en la cláusula HAVING se filtran los resultados para seleccionar los actores que tienen más de 10 películas

SELECT `a`.`first_name`, `a`.`last_name`
	FROM `actor` AS `a`
    INNER JOIN `film_actor` AS `fa`
		ON `a`.`actor_id` = `fa`.`actor_id`
	GROUP BY `a`.`actor_id`
		HAVING COUNT(`fa`.`film_id`) > 10
	ORDER BY `a`.`last_name`;
    

/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.
*/

SELECT `title` -- , `rating`, `length`
	FROM `film`
    WHERE `rating` = 'R' AND `length` > 120;
    

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
*/
-- uso de tres INNER JOIN para conectar las tablas category, film_category y film. Se agrupan los resultados por en nombre de la categoría
-- en la cláusula HAVING se filtra por promedio de duración

SELECT `c`.`name`, AVG(`f`.`length`) AS `length_avg`
	FROM `category` AS `c`
    INNER JOIN `film_category` AS `fc`
		ON `c`.`category_id` = `fc`.`category_id`
	INNER JOIN `film` AS `f`
		ON `fc`.`film_id` = `f`.`film_id`
	GROUP BY `c`.`name`
		HAVING AVG(`length`) > 120;
        
/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
*/

SELECT CONCAT(`a`.`first_name`, ' ', `a`.`last_name`) AS `nombre`, COUNT(`fa`.`film_id`) AS `films`
	FROM `actor` AS `a`
    INNER JOIN `film_actor` AS `fa`
		ON `a`.`actor_id` = `fa`.`actor_id`
	GROUP BY `a`.`actor_id`
		HAVING COUNT(`fa`.`film_id`) >= 5
	ORDER BY `films`;

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
*/
-- uso de INNER JOIN entre las tablas rental e inventory
-- uso de la función DATEDIFF para calcular la diferencia de días entre la fecha de devolución y la de alquiler
-- filtrado mediante la cláusula WHERE

-- subconsulta: 
SELECT DISTINCT `i`.`film_id` -- uso de DISTINCT para que no haya duplicados
	FROM `rental` AS `r`
    INNER JOIN `inventory` AS `i` 
		ON `r`.`inventory_id` = `i`.`inventory_id`
    WHERE DATEDIFF(`return_date`, `rental_date`) > 5; 
    
-- introducir la subconsulta en la consulta:

SELECT `title`
	FROM `film`
    WHERE `film_id` IN (SELECT DISTINCT `i`.`film_id`
							FROM `rental` AS `r`
							INNER JOIN `inventory` AS `i`
								ON `r`.`inventory_id` = `i`.`inventory_id`
							WHERE DATEDIFF(`return_date`, `rental_date`) > 5
                            );


/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
*/

-- subconsulta:
-- busco los IDs de los actores que han actuado en películas de la categoría 'Horror'

SELECT DISTINCT `fa`.`actor_id` -- uso de DISTINCT para que no haya duplicados
	FROM `category` AS `c` 
    INNER JOIN `film_category` AS `fc`
		ON `c`.`category_id` = `fc`.`category_id`
	INNER JOIN `film_actor` AS `fa`
		ON `fc`.`film_id` = `fa`.`film_id`
	WHERE `c`.`name` = 'Horror';
    
-- indroducción de la subconsulta en la consulta: 
-- mediante el uso de NOT IN excluyo los IDs de los actores que habían actuado en películas de horror

SELECT CONCAT(`first_name`, ' ', `last_name`) AS `name`, `actor_id`
	FROM `actor`
    WHERE `actor_id` NOT IN (SELECT DISTINCT `fa`.`actor_id` 
								FROM `category` AS `c` 
								INNER JOIN `film_category` AS `fc`
									ON `c`.`category_id` = `fc`.`category_id`
								INNER JOIN `film_actor` AS `fa`
									ON `fc`.`film_id` = `fa`.`film_id`
								WHERE `c`.`name` = 'Horror'
                                )
	ORDER BY `last_name`;
    
/* BONUS
*/

/* 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.
*/

-- subconsulta
-- selecciono los IDs de las películas que pertenecen a la categoría 'Comedia'
SELECT `f`.`film_id`
	FROM `category` AS `c` 
    INNER JOIN `film_category` AS `fc`
		ON `c`.`category_id` = `fc`.`category_id`
	INNER JOIN `film` AS `f`
		ON `fc`.`film_id` = `f`.`film_id`
	WHERE `c`.`name` = 'Comedy';

-- se seleccionan los títulos de las películas de los IDs anteriores y con una duración mayor a 180 min. 

SELECT `title` -- , `length`
	FROM `film`
    WHERE `film_id` IN (SELECT `f`.`film_id`
							FROM `category` AS `c` 
							INNER JOIN `film_category` AS `fc`
								ON `c`.`category_id` = `fc`.`category_id`
							INNER JOIN `film` AS `f`
								ON `fc`.`film_id` = `f`.`film_id`
							WHERE `c`.`name` = 'Comedy')
						AND `length` > 180;
                        
/* 25. Encuentra todos los actores que han actuado juntos en al menos una película. 
La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
*/

-- subconsulta
-- obtener todas las combinaciones únicas de pares de actores que han aparecido juntos en alguna película. Para eso realizo un INNER JOIN con la propia tabla

SELECT `fa1`.`actor_id` AS `actor1_id`, `fa2`.`actor_id` AS `actor2_id`
	FROM `film_actor` AS `fa1`
    INNER JOIN `film_actor` AS `fa2` 
		ON `fa1`.`film_id` = `fa2`.`film_id` AND `fa1`.`actor_id` < `fa2`.`actor_id`; -- esta última parte es para que no se duplique el resultado. 
    
-- 

SELECT CONCAT(`a1`.`first_name`, ' ', `a1`.`last_name`) AS `name_actor1`,
	CONCAT(`a2`.`first_name`, ' ', `a2`.`last_name`) AS `name_actor2`,
	COUNT(*) AS `movies_tog`
        
	FROM (SELECT `fa1`.`actor_id` AS `actor1_id`, `fa2`.`actor_id` AS `actor2_id`
			FROM `film_actor` AS `fa1`
			INNER JOIN `film_actor` AS `fa2` 
				ON `fa1`.`film_id` = `fa2`.`film_id` AND `fa1`.`actor_id` < `fa2`.`actor_id`) AS `subquery`
	INNER JOIN `actor` AS `a1`
		ON `subquery`.`actor1_id` = `a1`.`actor_id`
	INNER JOIN `actor` AS `a2`
		ON `subquery`.`actor2_id` = `a2`.`actor_id`
	GROUP BY `actor1_id`, `actor2_id`
    HAVING `movies_tog` > 0;
