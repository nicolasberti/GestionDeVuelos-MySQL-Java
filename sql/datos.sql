# Carga de datos de prueba

use vuelos;

# Algunos datos. La verdad que desconozco de fabricantes de aviones y de más, asi que inventé datos que tengan un poco de coherencia xd
# Formato de la fecha: AÑO-MES-DIA
INSERT INTO ubicaciones VALUES ("Argentina", "Buenos Aires", "Buenos Aires", -3);
INSERT INTO ubicaciones VALUES ("Inglaterra", "UK", "Londres", +1);
INSERT INTO ubicaciones VALUES ("Espania", "Madrid", "Madrid", +2);
INSERT INTO ubicaciones VALUES ("Argentina", "Río Negro", "Bariloche", -3);
INSERT INTO ubicaciones VALUES ("Estados Unidos", "New York", "New York", -4);
INSERT INTO ubicaciones VALUES ("Colombia", "Cundinamarca", "Bogota", -5);

INSERT INTO aeropuertos VALUES ("Argentina1", "Ezeiza", "111", "KM 12", "Argentina", "Buenos Aires", "Buenos Aires");
INSERT INTO aeropuertos VALUES ("UK1", "Londres OFICIAL", "222", "KM 5623", "Inglaterra", "UK", "Londres");
INSERT INTO aeropuertos VALUES ("COL1", "Aero. Col", "333", "KM 35", "Colombia", "Cundinamarca", "Bogota");
INSERT INTO aeropuertos VALUES ("ESP1", "ESP-AV", "444", "Aeroparque", "Espania", "Madrid", "Madrid");
INSERT INTO aeropuertos VALUES ("Argentina2", "Aero Bariloche", "555","Calle 24", "Argentina", "Río Negro", "Bariloche");
INSERT INTO aeropuertos VALUES ("USAIR", "Airport US", "666", "Calle 123", "Estados Unidos", "New York", "New York");

#numero, #aeropuerto salida, aeropuerto entrada, codigos de aeropuertos
INSERT INTO vuelos_programados VALUES ("AA-12", "Argentina1", "UK1");
INSERT INTO vuelos_programados VALUES ("AA-15", "Argentina2", "Argentina1");
INSERT INTO vuelos_programados VALUES ("AA-15-V", "Argentina1", "Argentina2");
INSERT INTO vuelos_programados VALUES ("AA-25", "Argentina2", "USAIR");
INSERT INTO vuelos_programados VALUES ("AA-51", "UK1", "ESP1");
INSERT INTO vuelos_programados VALUES ("AA-74", "ESP1", "COL1");

# Modelo, Fabricante, Cabinas, Cantidad de asientos
# Pongo cualquier fabricante ya que desconzco de fabricantes de aviones...
INSERT INTO modelos_avion VALUES("JW 453", "Toyota", 10, 150);
INSERT INTO modelos_avion VALUES("JW 900", "Toyota", 5, 100);
INSERT INTO modelos_avion VALUES("OP-M2", "Hyundai", 20, 200);
INSERT INTO modelos_avion VALUES("NJ-111", "Ford", 10, 100);
INSERT INTO modelos_avion VALUES("OT-P-123", "Ford", 20, 300);

INSERT INTO salidas VALUES ("AA-12", "Lu", "12:10:00", "16:10:00", "JW 453");
INSERT INTO salidas VALUES ("AA-15", "Do", "12:00:00", "15:00:00", "JW 453");
INSERT INTO salidas VALUES ("AA-15-V", "Ma", "11:30:00", "23:00:00", "JW 900");
INSERT INTO salidas VALUES ("AA-25", "Sa", "23:00:00", "12:00:00", "OP-M2");
INSERT INTO salidas VALUES ("AA-51", "Lu", "14:00:00", "16:30:00", "NJ-111");
INSERT INTO salidas VALUES ("AA-74", "Ju", "15:30:00", "11:30:00", "OT-P-123");
/*
# Formato de fecha: AÑO-MES-DIA
INSERT INTO instancias_vuelo VALUES ("AA-12", '2022-9-9', "Lu", "A tiempo");
INSERT INTO instancias_vuelo VALUES ("AA-15", '2022-8-6', "Do", "Demorado");
INSERT INTO instancias_vuelo VALUES ("AA-15-V", '2022-12-7', "Ma", "Cancelado");
INSERT INTO instancias_vuelo VALUES ("AA-25", '2022-8-20', "Sa", "Demorado");
INSERT INTO instancias_vuelo VALUES ("AA-51", '2022-10-26', "Lu", "A tiempo");
INSERT INTO instancias_vuelo VALUES ("AA-74", '2022-9-9', "Ju", "A tiempo");
*/
INSERT INTO clases VALUES("Primera", 0.85);
INSERT INTO clases VALUES("Turista", 0.15);

INSERT INTO comodidades VALUES (1, "Televisión");
INSERT INTO comodidades VALUES (2, "Desayuno");
INSERT INTO comodidades VALUES (3, "Bebidas");
INSERT INTO comodidades VALUES (4, "Internet");
INSERT INTO comodidades VALUES (5, "Aire acondicionado");

INSERT INTO posee VALUES ("Primera", 1);
INSERT INTO posee VALUES ("Primera", 2);
INSERT INTO posee VALUES ("Primera", 3);
INSERT INTO posee VALUES ("Primera", 4);
INSERT INTO posee VALUES ("Primera", 5);

INSERT INTO posee VALUES ("Turista", 2);
INSERT INTO posee VALUES ("Turista", 3);
INSERT INTO posee VALUES ("Turista", 4);
INSERT INTO posee VALUES ("Turista", 5); 

INSERT INTO brinda VALUES("AA-12", "Lu", "Primera", 500.99, 100);
INSERT INTO brinda VALUES("AA-12", "Lu", "Turista", 300.99, 50);
INSERT INTO brinda VALUES("AA-15", "Do", "Primera", 600.00, 150);
INSERT INTO brinda VALUES("AA-15-V", "Ma", "Primera", 300.00, 70);
INSERT INTO brinda VALUES("AA-15-V", "Ma", "Turista", 100.00, 30);
INSERT INTO brinda VALUES("AA-25", "Sa", "Turista", 50.00, 200);
INSERT INTO brinda VALUES("AA-51", "Lu", "Turista", 100.00, 100);
INSERT INTO brinda VALUES("AA-74", "Ju", "Primera", 300.00, 100);
INSERT INTO brinda VALUES("AA-74", "Ju", "Turista", 50.00, 200);

#####################

INSERT INTO pasajeros VALUES("DNI", 100, "Berti", "Nicolas", "Naposta 161", "2920642002", "Argentina");
INSERT INTO pasajeros VALUES("DNI", 101, "Berti", "Emiliano", "Naposta 161", "293145632", "Argentina");
INSERT INTO pasajeros VALUES("DNI", 102, "De Giusti", "Tomas", "Florencio Sanchez 573", "2984739927","Argentina");
INSERT INTO pasajeros VALUES("DNI", 103, "Perez", "Juan", "Sarmiento 25", "2913244242","Argentina");
INSERT INTO pasajeros VALUES("DNI", 104, "Puerta", "Martin", "Av. Alem 247", "2984910293","Bolivia");
INSERT INTO pasajeros VALUES("DNI", 105, "Jobs", "Steve", "Peru 29", "258895474","Estados Unidos");
INSERT INTO pasajeros VALUES("DNI", 106, "Gates", "Bill", "Paraguay 14", "2984525264","Estados Unidos");

INSERT INTO pasajeros VALUES("DNI", 107, "Gallanto", "Marcelo", "Nacional B 514", "2984513264","Argentina");
INSERT INTO pasajeros VALUES("DNI", 108, "Federer", "Roger", "Alsina 123", "312345264","Suiza");
INSERT INTO pasajeros VALUES("DNI", 109, "Turing", "Alan", "Florida 312", "1234125511","Inglaterra");

INSERT INTO empleados VALUES(125, MD5("empleado"), "DNI", 496, "Rodriguez", "Agustin", "Las Heras", "45226");
INSERT INTO empleados VALUES(126, MD5("empleado"), "DNI", 587, "Benedetto", "Dario", "Av. Alem 1561", "156481235");
INSERT INTO empleados VALUES(127, MD5("empleado"), "DNI", 548, "Riquelme", "Juan Roman", "Casanova 16", "56489465");
INSERT INTO empleados VALUES(128, MD5("empleado"), "DNI", 587, "Messi", "Lionel", "Caronti 124", "564868942");
INSERT INTO empleados VALUES(129, MD5("empleado"), "DNI", 512, "Scaloni", "Lionel", "19 de abril 24", "156187972");
INSERT INTO empleados VALUES(130, MD5("empleado"), "DNI", 648, "Londra", "Paulo", "Alsina 192", "15489235");
INSERT INTO empleados VALUES(131, MD5("empleado"), "DNI", 895, "Alvarez", "Julian", "Martin fierro 2390", "4689432");

/*
INSERT INTO reservas VALUES (111, "2022-9-5", "2022-10-5", "Confirmada", "DNI", 100, 125);
INSERT INTO reservas VALUES (112, "2022-9-5", "2022-10-5", "Confirmada", "DNI", 101, 125);
INSERT INTO reservas VALUES (113, "2022-8-5", "2022-9-5", "En espera", "DNI", 102, 126);
INSERT INTO reservas VALUES (114, "2022-4-4", "2022-4-5", "Pagada", "DNI", 103, 128);
INSERT INTO reservas VALUES (115, "2022-11-5", "2022-12-5", "En espera", "DNI", 104, 129);
INSERT INTO reservas VALUES (116, "2022-5-14", "2022-5-15", "Pagada", "DNI", 105, 127);

INSERT INTO reservas VALUES (117, "2022-4-19", "2022-4-20", "Pagada", "DNI", 106, 130);

INSERT INTO reservas VALUES (118, "2022-4-4", "2022-4-5", "Pagada", "DNI", 107, 128);
INSERT INTO reservas VALUES (119, "2022-4-2", "2022-4-4", "Pagada", "DNI", 108, 129);
INSERT INTO reservas VALUES (120, "2022-3-4", "2022-3-5", "Pagada", "DNI", 109, 131);
INSERT INTO reservas VALUES (121, "2022-2-4", "2022-2-5", "Pagada", "DNI", 105, 130);
INSERT INTO reservas VALUES (122, "2022-1-4", "2022-1-6", "Pagada", "DNI", 104, 125);
INSERT INTO reservas VALUES (123, "2022-7-4", "2022-7-8", "Pagada", "DNI", 103, 126);
INSERT INTO reservas VALUES (124, "2022-6-4", "2022-6-15", "Pagada", "DNI", 102, 127);
INSERT INTO reservas VALUES (125, "2022-2-4", "2022-2-5", "Pagada", "DNI", 101, 128);
INSERT INTO reservas VALUES (126, "2022-5-6", "2022-5-8", "Pagada", "DNI", 104, 129);
INSERT INTO reservas VALUES (127, "2022-7-8", "2022-7-9", "Pagada", "DNI", 107, 130);
INSERT INTO reservas VALUES (128, "2022-6-4", "2022-6-7", "Pagada", "DNI", 108, 125);
INSERT INTO reservas VALUES (129, "2022-10-4", "2022-10-6", "Pagada", "DNI", 109, 127);
INSERT INTO reservas VALUES (130, "2022-10-14", "2022-10-15", "Pagada", "DNI", 105, 128);
INSERT INTO reservas VALUES (131, "2022-11-4", "2022-11-6", "Pagada", "DNI", 102, 129);
INSERT INTO reservas VALUES (132, "2022-12-4", "2022-12-7", "Pagada", "DNI", 106, 126);

#numreserva, vuelo, fechavuelo, clase 
INSERT INTO reserva_vuelo_clase VALUES (111, "AA-12", '2022-9-9', "Primera");
INSERT INTO reserva_vuelo_clase VALUES (111, "AA-15", '2022-8-6', "Primera"); #reserva ida y vuelta

INSERT INTO reserva_vuelo_clase VALUES (112, "AA-12", '2022-9-9', "Primera");
INSERT INTO reserva_vuelo_clase VALUES (113, "AA-12", '2022-9-9', "Primera");
INSERT INTO reserva_vuelo_clase VALUES (114, "AA-12", '2022-9-9', "Primera");
INSERT INTO reserva_vuelo_clase VALUES (115, "AA-12", '2022-9-9', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (116, "AA-12", '2022-9-9', "Primera");

INSERT INTO reserva_vuelo_clase VALUES (117, "AA-15", '2022-8-6', "Primera");

INSERT INTO reserva_vuelo_clase VALUES (118, "AA-15-V", '2022-12-7', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (119, "AA-15-V", '2022-12-7', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (120, "AA-15-V", '2022-12-7', "Primera");
INSERT INTO reserva_vuelo_clase VALUES (121, "AA-15-V", '2022-12-7', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (122, "AA-15-V", '2022-12-7', "Turista");

INSERT INTO reserva_vuelo_clase VALUES (123, "AA-25", '2022-8-20', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (124, "AA-25", '2022-8-20', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (125, "AA-25", '2022-8-20', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (126, "AA-25", '2022-8-20', "Turista");

INSERT INTO reserva_vuelo_clase VALUES (128, "AA-51", '2022-10-26', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (129, "AA-51", '2022-10-26', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (130, "AA-51", '2022-10-26', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (131, "AA-51", '2022-10-26', "Turista");
INSERT INTO reserva_vuelo_clase VALUES (132, "AA-51", '2022-10-26', "Turista");
*/



#INSERT INTO asientos_reservados VALUES ("AA-12", '2022-9-9', "Primera", 5);
#INSERT INTO asientos_reservados VALUES ("AA-12", '2022-9-9', "Turista", 1);

#INSERT INTO asientos_reservados VALUES ("AA-15", '2022-8-6', "Primera", 1);

#INSERT INTO asientos_reservados VALUES ("AA-15-V", '2022-12-7', "Turista", 4);
#INSERT INTO asientos_reservados VALUES ("AA-15-V", '2022-12-7', "Primera", 1);

#INSERT INTO asientos_reservados VALUES ("AA-25", '2022-8-20', "Turista", 4);

#INSERT INTO asientos_reservados VALUES ("AA-51", '2022-10-26', "Turista", 5);



