#Archivo batch (batalllas.sql) para la creación de la 
#Base de datos del proyecto-2. Correspondiente a una base de datos de vuelos

# Creo de la Base de Datos
CREATE DATABASE vuelos;

# selecciono la base de datos sobre la cual voy a hacer modificaciones
USE vuelos;

# ----------------------------------------------------------------------------------------------------
# Creación de tablas para las entidades y relaciones.


CREATE TABLE ubicaciones (
	pais		VARCHAR(20) NOT NULL,
	estado		VARCHAR(20) NOT NULL,
	ciudad		VARCHAR(20) NOT NULL,
	huso		INT CHECK ((HUSO > -12) AND (HUSO < 12)) NOT NULL,
	CONSTRAINT pk_ubicaciones 
		PRIMARY KEY(pais, estado, ciudad)
) ENGINE=InnoDB;

CREATE TABLE modelos_avion (
	modelo 			VARCHAR(20) NOT NULL,
	fabricante		VARCHAR(20) NOT NULL,
	cabinas			INT UNSIGNED NOT NULL,
	cant_asientos	INT UNSIGNED NOT NULL,
	CONSTRAINT pk_modelo_modelos_avion
		PRIMARY KEY(modelo)
) ENGINE=InnoDB;

CREATE TABLE pasajeros
(	doc_tipo VARCHAR(45) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	telefono VARCHAR(15) NOT NULL,
	nacionalidad VARCHAR(20) NOT NULL,
	CONSTRAINT pk_pasajero 
		PRIMARY KEY (doc_tipo, doc_nro)
) ENGINE=InnoDB;

CREATE TABLE empleados
(	legajo INT UNSIGNED NOT NULL,
	password VARCHAR(32) NOT NULL,
	doc_tipo VARCHAR(45) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	telefono VARCHAR(15) NOT NULL,
	CONSTRAINT pk_empleado 
		PRIMARY KEY (legajo)
) ENGINE=InnoDB;

CREATE TABLE clases (
	nombre			VARCHAR(20) NOT NULL,
	porcentaje		DECIMAL(2,2) UNSIGNED NOT NULL, #si pongo UNSIGNED me tira warning
	CONSTRAINT pk_nombre_clases
		PRIMARY KEY(nombre),
	CHECK (porcentaje <= 00.99)
) ENGINE=InnoDB;


CREATE TABLE comodidades (
	codigo INT UNSIGNED NOT NULL, 
	descripcion TEXT NOT NULL,
	CONSTRAINT pk_comodidad 
		PRIMARY KEY (codigo) 
) ENGINE=InnoDB;

# Tablas con referencia
	
CREATE TABLE aeropuertos (
	codigo		VARCHAR(45) NOT NULL,
	nombre 		VARCHAR(40) NOT NULL,
	telefono	VARCHAR(15) NOT NULL,
	direccion 	VARCHAR(30) NOT NULL,
	pais		VARCHAR(20) NOT NULL,
	estado		VARCHAR(20) NOT NULL,
	ciudad		VARCHAR(20) NOT NULL,
	
	CONSTRAINT FK_codigo_aeropuertos
		PRIMARY KEY(codigo),
	
	CONSTRAINT FK_aeropuertospais
		FOREIGN KEY (pais, estado, ciudad) REFERENCES ubicaciones (pais, estado, ciudad)
			ON DELETE RESTRICT ON UPDATE CASCADE
	 
) ENGINE=InnoDB;


CREATE TABLE vuelos_programados (
	numero				VARCHAR(10) NOT NULL,
	aeropuerto_salida	VARCHAR(45) NOT NULL,
	aeropuerto_llegada	VARCHAR(45) NOT NULL,
	
	CONSTRAINT pk_vuelos_programados
		PRIMARY KEY (numero),
		
	FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos (codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
		
	FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos (codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE salidas (
	vuelo			VARCHAR(10) NOT NULL, 
	dia				ENUM("Do","Lu","Ma","Mi","Ju","Vi","Sa"),
	hora_sale		TIME NOT NULL, 
	hora_llega 		TIME NOT NULL,
	modelo_avion	VARCHAR(20) NOT NULL,
	
	PRIMARY KEY(vuelo, dia),
	
	FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(modelo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	FOREIGN KEY (vuelo) REFERENCES vuelos_programados(numero)
		ON DELETE RESTRICT ON UPDATE CASCADE
	
) ENGINE=InnoDB;

CREATE TABLE reservas
(	numero 		INT UNSIGNED NOT NULL AUTO_INCREMENT,
	fecha		DATE NOT NULL,
	vencimiento DATE NOT NULL,
	estado 		VARCHAR(15) NOT NULL,
	doc_tipo 	VARCHAR(45) NOT NULL,
	doc_nro 	INT UNSIGNED NOT NULL,
	legajo 		INT UNSIGNED NOT NULL,
	# Llave primaria
	CONSTRAINT pk_reserva PRIMARY KEY (numero),
	# Llaves foraneas
		FOREIGN KEY (doc_tipo, doc_nro) REFERENCES pasajeros (doc_tipo, doc_nro) 
			ON DELETE RESTRICT ON UPDATE CASCADE,
		FOREIGN KEY (legajo) REFERENCES empleados (legajo) 
			ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE brinda
(	vuelo VARCHAR(10) NOT NULL,
	dia ENUM("Do","Lu","Ma","Mi","Ju","Vi","Sa"),
	clase VARCHAR(20) NOT NULL,
	precio DECIMAL(7, 2) UNSIGNED NOT NULL,
	cant_asientos INT UNSIGNED NOT NULL,
	
	#Llave primaria
	CONSTRAINT pk_brinda PRIMARY KEY (vuelo, dia, clase),
	# Llaves foraneas
		FOREIGN KEY (vuelo, dia) REFERENCES salidas (vuelo, dia) 
			ON DELETE RESTRICT ON UPDATE CASCADE,
		FOREIGN KEY (clase) REFERENCES clases (nombre) 
			ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE posee
( 	clase VARCHAR(20) NOT NULL,
	comodidad INT UNSIGNED NOT NULL,
	#Llave primaria
	CONSTRAINT pk_posee PRIMARY KEY (clase, comodidad),
	#Llaves foraneas
		FOREIGN KEY (clase) REFERENCES clases (nombre) 
			ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_comodidad 
		FOREIGN KEY (comodidad) REFERENCES comodidades (codigo) 
			ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;	

CREATE TABLE instancias_vuelo (
	vuelo			VARCHAR(10) NOT NULL, 
	fecha 			DATE NOT NULL,
	dia 			ENUM("Do","Lu","Ma","Mi","Ju","Vi","Sa") NOT NULL,
	estado 			VARCHAR(15) NULL,  #A tiempo, demorado, cancelado
	
	CONSTRAINT pk_instanciasvuelo PRIMARY KEY (vuelo, fecha),
	
	FOREIGN KEY (vuelo, dia) REFERENCES salidas (vuelo, dia) 
			ON DELETE RESTRICT ON UPDATE CASCADE
	
) ENGINE=InnoDB;

CREATE TABLE reserva_vuelo_clase
(	numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
	vuelo VARCHAR(10) NOT NULL,
	fecha_vuelo DATE NOT NULL,
	clase VARCHAR(20) NOT NULL,
	#Llave primaria
	CONSTRAINT pk_reserva_vuelo_clase PRIMARY KEY (numero, vuelo, fecha_vuelo),
	
	#Llave foraneas
	FOREIGN KEY (numero) REFERENCES reservas (numero) 
			ON DELETE RESTRICT ON UPDATE CASCADE,

	FOREIGN KEY (vuelo, fecha_vuelo) REFERENCES instancias_vuelo (vuelo, fecha) 
			ON DELETE RESTRICT ON UPDATE CASCADE,
	
	FOREIGN KEY (clase) REFERENCES clases (nombre) 
			ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE asientos_reservados
(	vuelo VARCHAR(10) NOT NULL,
	fecha DATE NOT NULL,
	clase VARCHAR(20) NOT NULL,
	cantidad INT UNSIGNED NOT NULL,
	#Llave primaria
	CONSTRAINT pk_asientos_reservados PRIMARY KEY (vuelo, fecha, clase),
	#Llaves foraneas
		FOREIGN KEY (vuelo, fecha) REFERENCES instancias_vuelo (vuelo, fecha) 
			ON DELETE RESTRICT ON UPDATE CASCADE, 
		FOREIGN KEY (clase) REFERENCES clases (nombre) 
			ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

# ----------------------------------------------------------------------------------------------------
# Creación de la vista "vuelos_disponibles" 

CREATE VIEW vuelos_disponibles AS 
	select nro_vuelo, modelo, YY.fecha, dia_sale, hora_sale, hora_llega, cant_asientos, tiempo_estimado, codigo_aero_sale, nombre_aero_sale, ciudad_sale, estado_sale, pais_sale,
codigo_aero_llega, nombre_aero_llega, ciudad_llega, estado_llega, pais_llega, precio, YY.clase,
	IFNULL(round((YY.cant_asientos + (YY.porcentaje*YY.cant_asientos))-X.cantidad), cant_asientos) as asientos_disponibles
		/* En caso de que el valor sea null por el LEFT JOIN, entonces pone la cantidad de asientos disponibles es igual a la cantidad de asientos */
from 
	# Sub-consulta que genera el tiempo estimado con un casteo del huso horario.
	(select vuelo as nro_vuelo, modelo_avion as modelo, fecha, dia as dia_sale, hora_sale, hora_llega, cant_asientos, porcentaje, 
				# -- Cálculo del tiempo estimado. Se hace un casteo del huso horario para tenerlo en formato -+ NUMERONUMERO:NUMERONUMERO donde NUMERO pertenece a [0, 12]	--
				# En caso de que la hora_llega_convertida (hora convertida al huso horario de la hora_sale) sea menor que la hora_sale es que se llega al día próximo
				# Entonces, el algoritmo hace lo siguiente. (Haciendo sus respectivos casteos por el HUSO HORARIO)
				/*
					if(hora_llega_convertida < hora_sale)
						tiempo_estimado = 24hs - |hora_llega_convertida-hora_sale|
					else
						tiempo_estimado = hora_llega_convertida - hora_sale
						
					OBS: El algoritmo solo se fija si llega un día después, no dos días, tres días y así... Es decir, asume que no hay vuelos más de 24 horas.
				*/
				IF( (timediff(cast(CONVERT_TZ(CONCAT(fecha, " ", hora_llega), #se calcula la diferencia para saber el tiempo estimado
					IF(D.huso <0,
						IF(D.huso > -9, 
							CONCAT("-0", -1*D.huso, ":00"), 
						# else
						CONCAT("-", D.huso, ":00"))
					#else
						,IF(D.huso < 9, 
							CONCAT("+0", D.huso, ":00"), 
						#else
						CONCAT("+", D.huso, ":00"))),
						
					IF(C.huso <0,
						IF(C.huso > -9, 
							CONCAT("-0", -1*C.huso, ":00"), 
						#else
							CONCAT("-", C.huso, ":00"))
					#else
						,IF(C.huso < 9, 
							CONCAT("+0", C.huso, ":00"), 
						#else	
							CONCAT("+", C.huso, ":00"))) ) as time), hora_sale)) <= 0,
					## Menor
						timediff("24:00:00", timediff(hora_sale, cast(CONVERT_TZ(CONCAT(fecha, " ", hora_llega), #se calcula la diferencia para saber el tiempo estimado
					IF(D.huso <0,
						IF(D.huso > -9, 
							CONCAT("-0", -1*D.huso, ":00"), 
						# else
						CONCAT("-", D.huso, ":00"))
					#else
						,IF(D.huso < 9, 
							CONCAT("+0", D.huso, ":00"), 
						#else
						CONCAT("+", D.huso, ":00"))),
						
					IF(C.huso <0,
						IF(C.huso > -9, 
							CONCAT("-0", -1*C.huso, ":00"), 
						#else
							CONCAT("-", C.huso, ":00"))
					#else
						,IF(C.huso < 9, 
							CONCAT("+0", C.huso, ":00"), 
						#else	
							CONCAT("+", C.huso, ":00"))) ) as time)))
					## Fin menor
					,
					## Calculo NORMAL
						timediff(cast(CONVERT_TZ(CONCAT(fecha, " ", hora_llega), #se calcula la diferencia para saber el tiempo estimado
					IF(D.huso <0,
						IF(D.huso > -9, 
							CONCAT("-0", -1*D.huso, ":00"), 
						# else
						CONCAT("-", D.huso, ":00"))
					#else
						,IF(D.huso < 9, 
							CONCAT("+0", D.huso, ":00"), 
						#else
						CONCAT("+", D.huso, ":00"))),
						
					IF(C.huso <0,
						IF(C.huso > -9, 
							CONCAT("-0", -1*C.huso, ":00"), 
						#else
							CONCAT("-", C.huso, ":00"))
					#else
						,IF(C.huso < 9, 
							CONCAT("+0", C.huso, ":00"), 
						#else	
							CONCAT("+", C.huso, ":00"))) ) as time), hora_sale)
					## Calculo NORMAL FIN
					) as tiempo_estimado ,
				# -- Fin calculo tiempo estimado --
				
		A.codigo as codigo_aero_sale, A.nombre as nombre_aero_sale, A.ciudad as ciudad_sale, A.estado as estado_sale, A.pais as pais_sale,
		B.codigo as codigo_aero_llega, B.nombre as nombre_aero_llega, B.ciudad as ciudad_llega, B.estado as estado_llega, B.pais as pais_llega,
		precio, clase
		from (vuelos_programados, instancias_vuelo, aeropuertos A, aeropuertos B, ubicaciones C, ubicaciones D, clases CL) NATURAL JOIN salidas NATURAL JOIN brinda
		where vuelo=numero and aeropuerto_salida = A.codigo and aeropuerto_llegada = B.codigo
				and A.ciudad = C.ciudad and A.estado = C.estado and A.pais = C.pais
					and B.ciudad = D.ciudad and B.estado = D.estado and B.pais = D.pais
						and CL.nombre = clase
	) YY LEFT JOIN asientos_reservados X ON YY.nro_vuelo = X.vuelo AND YY.fecha = X.fecha AND YY.clase = X.clase;
/* Este left join sirve para calcular "null" en caso de que no haya asientos reservados en un cierto vuelo. */
#--------------------------------------------------------
# Creación de usuarios y permisos

/* linea para testear asi no tenemos q borrar los usuarios manualmente
#Para ejecutar la creación de usuarios no se debe tener los usuarios creados previamente.
DROP USER 'admin'@'localhost';
DROP USER ''@'localhost';
DROP USER 'cliente'@'localhost';
DROP USER 'empleado'@'%';*/

DROP USER ''@'localhost'; # Incluimos para que borre el usuario vacío en caso de que esté creado.

# Usuario: admin, Password: admin
# Este usuario tiene el acceso total sobre las tablas, con la opción de crear usuarios y 
# otorgar privelegios sobre la mismas. El acceso de este usuario se realiza solo desde la máquina
# local, donde se encuentra el servidor MySQL.

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';

# Usuario: empleado, Password: empleado
# Este usuario tiene acceso de lectura sobre todas las tablas de la base de datos vuelos.
# Tiene privilegios para ingresar, modificar y borrar datos sobre las tablas reservas, pasajeros
# y reserva_vuelo_clase. Este usuario podrá conectarse desde cualquier dominio.

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

# Usuario: cliente, Password: cliente
# El cliente tiene que tener acceso a la lectura de la vista vuelos_disponibles. Podrá conectarse
# desde cualquier dominio.

CREATE USER 'cliente'@'localhost' IDENTIFIED BY 'cliente'; # En el enunciado no especifica que cliente debe acceder desde cualquier dominio.
# Solo dice que el 'empleado' debe hacerlo. Asi que ponemos cliente que solo acceda desde localhost.

# --------------------------------------
# Permisos de usuarios
# Otorga todos los permisos al usuario 'admin'
GRANT ALL PRIVILEGES ON vuelos.* TO 'admin'@'localhost' WITH GRANT OPTION;
# Otorgo permisos de lectura para el usuario empleado.
GRANT SELECT ON vuelos.* TO 'empleado'@'%';

# Otorgo permisos para ingresar, modificar y borrar datos sobre la tablas de reservas, pasajeros
# y reserva_vuelo_clase al usuario 'empleado'
GRANT INSERT, UPDATE, DELETE ON vuelos.reservas TO 'empleado'@'%';
GRANT INSERT, UPDATE, DELETE ON vuelos.pasajeros TO 'empleado'@'%';
GRANT INSERT, UPDATE, DELETE ON vuelos.reserva_vuelo_clase TO 'empleado'@'%';

#Otorgo permiso de lectura a la vista vuelos_disponibles al usuario 'cliente'
GRANT SELECT ON vuelos.vuelos_disponibles TO 'cliente'@'localhost';

# ----------------------------
# El trigger se invoca manualmente (por consola) pero no con \. datos.sql ¿Por qué? -> Le preguntamos a Diego y dijo que no había drama, mientras esté bien por consola.
DELIMITER $$
CREATE TRIGGER setAsientosCero
AFTER INSERT ON instancias_vuelo
FOR EACH ROW
BEGIN
  CALL pasientos_cero(NEW.vuelo, NEW.fecha);
END$$
DELIMITER ;

# Procedimiento que inserta en la tabla "asientos_reservados"
delimiter !
create procedure pasientos_cero(IN v CHAR(10), IN f DATE)
	begin
	declare fin boolean default false;
	declare var_vuelo CHAR(10);
	declare var_fecha DATE;
	declare var_clase CHAR(20);
	declare C cursor for SELECT vuelo, fecha, clase FROM instancias_vuelo natural join brinda where vuelo=v and fecha=f;
	declare continue handler for not found set fin = true;
	open C;
	fetch C into var_vuelo, var_fecha, var_clase;
	while not fin do
		insert into asientos_reservados values(var_vuelo, var_fecha, var_clase, 0);
		fetch C into var_vuelo, var_fecha, var_clase;
	end while;
	close C;
	end; !
delimiter ;


delimiter !
 CREATE FUNCTION whatday(fecha DATE) RETURNS CHAR(2)
 DETERMINISTIC
 BEGIN
   DECLARE i INT;   
   SELECT DAYOFWEEK(fecha) INTO i;
   CASE i
		WHEN 1 THEN RETURN 'Do';
		WHEN 2 THEN RETURN 'Lu';
		WHEN 3 THEN RETURN 'Ma';
		WHEN 4 THEN RETURN 'Mi';
		WHEN 5 THEN RETURN 'Ju';
		WHEN 6 THEN RETURN 'Vi';
		WHEN 7 THEN RETURN 'Sa';
	END CASE; 	
end; !
delimiter ;
 
# --------------------------- TRANSACCIONES -> STORE PROCEDURES RESERVA_VUELO_IDA, RESERVA_VUELO_IDA_VUELTA
# Números negativos -> errores
# Si retorna un número positivo, es el ID de la reserva.
delimiter !
CREATE PROCEDURE reserva_vuelo_ida(IN nro_vuelo_reserva CHAR(10), IN fecha_reserva DATE, IN clase_reserva CHAR(20), IN doc_tipo CHAR(45), IN doc_nro INT, IN legajo_empleado INT)
	begin
		declare cant_reservados INT;
		declare cant_disponibles INT;
		declare fecha_actual DATE;
		declare cant_brinda INT;
		
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SELECT '-1' as resultado;
			rollback;
		END;
		
		SET fecha_actual = CURDATE();
		START TRANSACTION;
			IF EXISTS (SELECT * FROM vuelos_disponibles WHERE nro_vuelo = nro_vuelo_reserva and fecha = fecha_reserva AND clase = clase_reserva) THEN
				select cantidad INTO cant_reservados from asientos_reservados where vuelo = nro_vuelo_reserva and clase = clase_reserva and fecha = fecha_reserva FOR UPDATE; #selecciona la cantidad de asientos reservados para ese vuelo y esa clase. bloqueo modo exclusivo.
				select asientos_disponibles INTO cant_disponibles from vuelos_disponibles where nro_vuelo = nro_vuelo_reserva AND fecha = fecha_reserva AND clase = clase_reserva;
				-- aca esta el error, tenemos que especificar el día. -> lo modifiqué agregando la función día. idem para el otro.
				select cant_asientos INTO cant_brinda from brinda where vuelo = nro_vuelo_reserva and clase=clase_reserva and dia=whatday(fecha_reserva);
				
				if cant_disponibles > 0 THEN # Hay lugares disponibles.
					if cant_reservados < cant_brinda THEN
					# Estado "confirmada"
						INSERT INTO reservas (fecha, vencimiento, estado, doc_tipo, doc_nro, legajo) values (fecha_actual, DATE_SUB(fecha_reserva, INTERVAL 15 DAY), "Confirmada", doc_tipo, doc_nro, legajo_empleado);
						INSERT INTO reserva_vuelo_clase values (LAST_INSERT_ID(), nro_vuelo_reserva, fecha_reserva, clase_reserva);
						UPDATE asientos_reservados SET cantidad = cantidad + 1 WHERE vuelo = nro_vuelo_reserva and fecha = fecha_reserva and clase = clase_reserva;
					else
					# Estado "en espera"
						INSERT INTO reservas (fecha, vencimiento, estado, doc_tipo, doc_nro, legajo) values (fecha_actual, DATE_SUB(fecha_reserva, INTERVAL 15 DAY), "En espera", doc_tipo, doc_nro, legajo_empleado);
						INSERT INTO reserva_vuelo_clase  values (LAST_INSERT_ID(), nro_vuelo_reserva, fecha_reserva, clase_reserva);
						end if;
					select LAST_INSERT_ID() as resultado;
				else
					select "-2" as resultado;
				end if;
			ELSE 
				select '-3' as resultado;
			END IF;
		COMMIT;
	end; !
delimiter ;

delimiter !
CREATE PROCEDURE reserva_vuelo_ida_vuelta(IN nro_vuelo_ida CHAR(10), IN nro_vuelo_vuelta CHAR(10), IN fecha_reserva_ida DATE, IN fecha_reserva_vuelta DATE, IN clase_reserva_ida CHAR(20), IN clase_reserva_vuelta CHAR(20), IN doc_tipo CHAR(45), IN doc_nro INT, IN legajo_empleado INT)
	begin
		declare cant_reservados_ida INT;
		declare cant_disponibles_ida INT;
		declare cant_brinda_ida INT;
		declare cant_reservados_vuelta INT;
		declare cant_disponibles_vuelta INT;
		declare cant_brinda_vuelta INT;
		
		declare fecha_actual DATE;
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SELECT '-1' as resultado;
			rollback;
		END;
		SET fecha_actual = CURDATE();
		START TRANSACTION;
			IF EXISTS (SELECT * FROM vuelos_disponibles WHERE nro_vuelo = nro_vuelo_ida and fecha = fecha_reserva_ida and clase = clase_reserva_ida) AND EXISTS (SELECT * FROM vuelos_disponibles WHERE nro_vuelo = nro_vuelo_vuelta and fecha = fecha_reserva_vuelta and clase = clase_reserva_vuelta)
			THEN
				select cantidad INTO cant_reservados_ida from asientos_reservados where vuelo = nro_vuelo_ida and clase = clase_reserva_ida and fecha = fecha_reserva_ida FOR UPDATE; #selecciona la cantidad de asientos reservados para ese vuelo y esa clase. bloqueo modo exclusivo.
				select cantidad INTO cant_reservados_vuelta from asientos_reservados where vuelo = nro_vuelo_vuelta and clase = clase_reserva_vuelta and fecha = fecha_reserva_vuelta FOR UPDATE; #selecciona la cantidad de asientos reservados para ese vuelo y esa clase. bloqueo modo exclusivo.
				select asientos_disponibles INTO cant_disponibles_ida from vuelos_disponibles where nro_vuelo = nro_vuelo_ida AND fecha = fecha_reserva_ida AND clase = clase_reserva_ida;
				select asientos_disponibles INTO cant_disponibles_vuelta from vuelos_disponibles where nro_vuelo = nro_vuelo_vuelta AND fecha = fecha_reserva_vuelta AND clase = clase_reserva_vuelta;
				select cant_asientos INTO cant_brinda_vuelta from brinda where vuelo = nro_vuelo_vuelta and clase = clase_reserva_vuelta and dia=whatday(fecha_reserva_vuelta);
				select cant_asientos INTO cant_brinda_ida from brinda where vuelo = nro_vuelo_ida and clase = clase_reserva_ida and dia=whatday(fecha_reserva_ida);
				if cant_disponibles_ida > 0 THEN
					if cant_disponibles_vuelta > 0 THEN
						if ( (cant_reservados_ida < cant_brinda_ida) AND (cant_reservados_vuelta < cant_brinda_vuelta) ) THEN
							# Estado "confirmada"
							INSERT INTO reservas (fecha, vencimiento, estado, doc_tipo, doc_nro, legajo) values (fecha_actual, DATE_SUB(fecha_reserva_ida, INTERVAL 15 DAY), "Confirmada", doc_tipo, doc_nro, legajo_empleado);
							INSERT INTO reserva_vuelo_clase values (LAST_INSERT_ID(), nro_vuelo_ida, fecha_reserva_ida, clase_reserva_ida);
							UPDATE asientos_reservados SET cantidad = cantidad + 1 WHERE vuelo = nro_vuelo_ida and fecha = fecha_reserva_ida and clase = clase_reserva_ida;
							INSERT INTO reserva_vuelo_clase values (LAST_INSERT_ID(), nro_vuelo_vuelta, fecha_reserva_vuelta, clase_reserva_vuelta);
							UPDATE asientos_reservados SET cantidad = cantidad + 1 WHERE vuelo = nro_vuelo_vuelta and fecha = fecha_reserva_vuelta and clase = clase_reserva_vuelta;
						else 
							# Estado "en espera"
							INSERT INTO reservas (fecha, vencimiento, estado, doc_tipo, doc_nro, legajo) values (fecha_actual, DATE_SUB(fecha_reserva_ida, INTERVAL 15 DAY), "En espera", doc_tipo, doc_nro, legajo_empleado);
							INSERT INTO reserva_vuelo_clase values (LAST_INSERT_ID(), nro_vuelo_ida, fecha_reserva_ida, clase_reserva_ida);
							INSERT INTO reserva_vuelo_clase values (LAST_INSERT_ID(), nro_vuelo_vuelta, fecha_reserva_vuelta, clase_reserva_vuelta);
						end if;
						select LAST_INSERT_ID() as resultado;
					else 
						select '-2' as resultado;
					end if;
				else
					select '-3' as resultado;
				end if;
			else
				select '-4' as resultado;
			END IF;
		COMMIT;
	end; !
delimiter ;

grant execute on procedure vuelos.reserva_vuelo_ida_vuelta to empleado;
grant execute on procedure vuelos.reserva_vuelo_ida to empleado;
