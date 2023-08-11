-- ========================== PROYECTO - DH-NOTICIAS =========================== --
-- =========================== RESOLUCION CHECKPOINT III ========================== --
-- GRUPO Nº:
-- Integrantes:

-- Base de datos: dh-noticias.sql
SET sql_mode = 'ONLY_FULL_GROUP_BY'; -- Esto permitirá detectar errores en la declaración de campos propios en las consultas agrupadas.

-- 1. Listar todos los autores que tengan más de diez artículos en nuestra base de datos. Mostrar apellido, nombre y la cantidad de artículos que posee.
select autores.nombre, autores.apellido,count(*) articulos from autores 
join articulos ON articulos.autores_id = autores.id
group by autores.nombre, autores.apellido
having count(*) > 10


-- 2  Listar todos los autores que no tengan articulos publicados en el blog. Mostrar  apellido y nombre 
-- mayúsculas dentro de una misma columna denominada "Autor sin publicacion".
SELECT CONCAT(nombre, ' ',apellido) as "Autor sin publicacion"
FROM autores au
LEFT JOIN articulos ar
ON au.id = ar.autores_id
WHERE ar.id is null

-- 3. Listar todos los autores que tengan al menos una publicacion y que tengan como origen el pais Chile. Se debe mostrar el apellido, nombre, 
-- titulo del articulo, fecha de la publicacion del articulo, nombre de la ciudad y país .
SELECT*
FROM articulos ar
join autores au
ON ar.autores_id=au.id
join ciudad ci
ON ci.id=au.ciudad_id
join pais pa
ON pa.id=ci.pais_id
WHERE estadoart=1 and pa.nombre= 'chile'
group by au.id;


-- 4. Listar los autores que tengan una o más articulos que no se encuentren publicados es decir que el estado se igual a cero  
-- y que en la segunda letra de su apellido contenga una "a".
SELECT * 
FROM autores au
LEFT JOIN articulos ar
ON au.id = ar.autores_id
WHERE au.apellido LIKE '_a%' 
and ar.estadoart=0;


-- 5. Listar absolutamente todos los países y la cantidad de autores que tengan.
SELECT count(au.id), pais.nombre  
FROM pais
LEFT JOIN ciudad c 
ON c.pais_id = pais.id
LEFT JOIN autores au 
ON c.id = au.ciudad_id 
GROUP BY pais.nombre

-- 6. Queremos conocer los comentarios que contengan la palabra "muy bueno", se pide el nombre y apellido del usuario, 
-- título del articulo y la fecha de publicación del comentario. 
SELECT comentarios.id, usuario.nombre , usuario.apellido , articulos.titulo , comentarios.Cometario , comentarios.Fecha 
FROM comentarios
INNER JOIN usuario
ON comentarios.usuario_id = usuario.id
INNER JOIN articulos
ON comentarios.articulos_id = articulos.id
WHERE comentarios.Cometario LIKE "%muy bueno%";


-- 7. Se necesita conocer todas las especialidades del autor Martin Guillermina Lucia 
SELECT *
FROM autores a
JOIN especialidad_x_autores ea
ON a.id = ea.autores_id
JOIN especialidad es
ON ea.especialidad_id = es.id
WHERE a.nombre LIKE 'Guillermina Lucia'


-- 8 Calcular la cantidad de autores por pais que no tengan asignada una especialidad .Para este informe mostrar el nombre del pais y la cantidad 
SELECT COUNT(*)  
FROM autores au
LEFT JOIN especialidad_x_autores es
ON au.id = es.autores_id
WHERE es.especialidad_id IS NULL;

-- 9.Se desea conocer el tercer autor que tenga más artículos publicados, el estado del mismo debe ser uno. 
-- Mostrar el nombre y apellido del autor, ciudad, país, estado de la publicación y la cantidad
SELECT au.nombre, apellido, estadoart, c.nombre, p.nombre, COUNT(ar.id)
FROM autores au
JOIN articulos ar
ON au.id = ar.autores_id
JOIN ciudad c
ON au.ciudad_id = c.id
JOIN pais p
ON c.pais_id = p.id
WHERE estadoart = 1
group by au.nombre
ORDER BY COUNT(ar.id) desc
limit 1
offset 2;


-- 10.	Calcular la cantidad de artículos por categoría inactiva (estado es igual a cero). Mostrar el nombre de la categoría y la cantidad.
SELECT count(*), nombre_categoria
FROM articulos a
JOIN subcategorias s
ON s.id = a.subcategorias_id
JOIN categorias c
ON s.categorias_id = categorias_id
WHERE estado_categoria = 0
group by nombre_categoria;


-- 11.	Listar todos los autores según la cantidad de artículos publicados, los mensajes serán los siguientes:
-- * "tiene solo un artículo publicado"
-- * "tiene dos artículos publicados"
-- * "tiene más dos artículos publicados"
-- * "no publico ningún articulo"
-- Mostrar el nombre y apellido del autor, como el mensaje que corresponda.*/
SELECT autores.id, autores.nombre , autores.apellido , COUNT(autores.id) AS total_articulos
FROM autores
INNER JOIN articulos
ON autores.id = articulos.autores_id
GROUP BY autores.id
ORDER BY total_articulos,
CASE 
	WHEN total_articulos = 0 THEN total_articulos = "no publico ningún articulo"
	WHEN total_articulos = 1 THEN total_articulos = "tiene solo un artículo publicado"
    WHEN total_articulos = 2 THEN total_articulos = "tiene dos artículos publicados"
    WHEN total_articulos > 3 THEN total_articulos = "tiene más dos artículos publicados"
END;


-- 12.	Calcular la cantidad de recursos utilizados en los artículos publicados (estado igual a uno) en el año 2022.
SELECT count(*)
FROM articulos
INNER JOIN recursos
ON articulos.id = recursos.articulos_id
WHERE estadoart = 1;


-- 13 Listar  los autores que tengan solo asignadas 3 especialidades.
select * 
from autores a
JOIN especialidad_x_autores e
ON a.id = e.autores_id

-- 14.	Calcular la cantidad de artículos de cada uno de los autores que no fueron publicados, para este informe necesitamos mostrar el usuario, correo electrónico, 
-- país, estado del articulo y la cantidad*/
select COUNT(*)
FROM autores
INNER JOIN articulos
ON autores.id = articulos.autores_id


-- 15 Listar todos los usuarios categorizados por edad. Las categorías son: 'junior' (hasta 35 años), 'semi-senior' (entre 36 a 40 años) y 'senior' (más de 40). 
-- Mostrar el apellido, nombre, edad, categoría y ordenar de mayor a menor por categoría y edad.
SELECT nombre, apellido, DATEDIFF(NOW(), fecha_nacimiento)
FROM usuario
CASE
WHEN DATEDIFF < 12775 THEN "junior"
WHEN DATEDIFF BETWEEN 12776 AND 14600 THEN "semi-senior"
ELSE "senior"
END;


-- 16. Listar de manera ordenada, los usuarios que no pertenezcan a  la ciudad "Monroe - Buenos Aires" y 
-- que la fecha de alta del cometario se halle dentro del rango 2019 al 2020. Mostrar el email del usuario, comentario realizado y  el nombre de la ciudad
-- Ordenar por fecha de comentario
SELECT   usu.nombre, usu.email, com.Cometario Comentario, c.nombre NombreDeLaCiudad
FROM usuario usu
inner join ciudad c
on usu.ciudad_id = c.id
join comentarios com
on usu.id = com.usuario_id
WHERE usu.id = com.Fecha BETWEEN '2019-04-17 00:00:00' AND '2022-07-06 00:00:00'
ORDER BY usu.nombre;

-- 17.	Calcular la cantidad de comentarios que realizaron los usuarios. Solo mostrar los cinco primeros, como también el nombre ,el apellido y país del usuario.
select nombre, apellido, ciudad_id
from usuario u
join comentarios c
on u.id = c.usuario_id
limit 5;

-- 18.	Listar los recursos del tipo audio y que tengan formato MP3 que fueron utilizados por los artículos con fecha de alta en el mes de octubre. 
-- Para este informe mostrar el título y fecha de alta del artículo, la ruta del recurso y la subcategoría.
SELECT * 
FROM recursos
WHERE ruta like '%.mp3%';

-- 19.	Listar todos los comentarios realizados por los usuarios que tengan entre 36 y 40 años. Mostrar nombre y apellido 
-- del usuario, ciudad, país y el comentario del mismo.

SELECT nombre, apellido, Cometario, ciudad_id
FROM comentarios
INNER JOIN usuario
ON comentarios.usuario_id = usuario.id
INNER JOIN articulos
ON comentarios.articulos_id = articulos.id;


-- 20 Listar de manera ordenada y ascendente por fecha de nacimiento, el nombre, apellido, ciudad de los usuarios 
-- y que la fecha de nacimiento sea mayor que 1989-02-12 o igual a 1979-12-17.

select *from  ciudad,usuario , count (*) 
order by fecha_nacimiento asc
having count(*) >  1989-02-12  or = 1979-12-17
