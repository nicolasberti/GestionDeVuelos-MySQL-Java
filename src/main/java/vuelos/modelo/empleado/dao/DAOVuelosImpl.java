package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.AeropuertoBeanImpl;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.DetalleVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;

public class DAOVuelosImpl implements DAOVuelos{

	private static Logger logger = LoggerFactory.getLogger(DAOVuelosImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOVuelosImpl(Connection conexion) {
		this.conexion = conexion;
	}

	@Override
	public ArrayList<InstanciaVueloBean> recuperarVuelosDisponibles(Date fechaVuelo, UbicacionesBean origen, UbicacionesBean destino)  throws Exception {
		/** 
		 * TODO Debe retornar una lista de vuelos disponibles para ese día con origen y destino según los parámetros. 
		 *      Debe propagar una excepción si hay algún error en la consulta.    
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).  
		 */
		// OK. Salvo lo de preguntas practica.txt
		
		ArrayList<InstanciaVueloBean> resultado = new ArrayList<InstanciaVueloBean>();  
		String fechaCasteada;
		
		fechaCasteada = (fechaVuelo.getYear() + 1900) + "-" + (fechaVuelo.getMonth() + 1) + "-"
				+ (fechaVuelo.getDate()); //getDay obtiene el numero del dia de la semana, nosotros necesitamos el numero del dia pero del mes

		//logger.debug("Test: Fecha casteada: "+fechaCasteada);
		
		//yyyy-MM-dd
		// correccion parte2 java.sql.Date fechaSQL = new java.sql.Date(fechaVuelo.getYear() + 1900, fechaVuelo.getMonth() + 1, fechaVuelo.getDate());
		
		try {
			
			// Modifique esta consulta porque salen dos vuelos iguales por el tema de las clases pero tendria que ser el mismo y despues se ve la clase.
			String sql = "SELECT DISTINCT nro_vuelo, modelo, fecha, dia_sale, hora_sale, hora_llega, tiempo_estimado, codigo_aero_sale, nombre_aero_sale, ciudad_sale, estado_sale, pais_sale, codigo_aero_llega, nombre_aero_llega, ciudad_llega, estado_llega, pais_llega";
			sql += " FROM vuelos_disponibles WHERE fecha = '"+fechaCasteada+"' ";
			//String sql = "SELECT * FROM vuelos_disponibles WHERE fecha = '" + fechaCasteada + "' ";
			
			sql += "AND ciudad_sale = '" + origen.getCiudad() + "' AND estado_sale = '" + origen.getEstado()
					+ "' AND pais_sale = '" + origen.getPais() + "' ";
			
			sql += "AND ciudad_llega = '" + destino.getCiudad() + "' AND estado_llega = '" + destino.getEstado()
					+ "' AND pais_llega = '" + destino.getPais() + "'";


			Statement select = conexion.createStatement();
			ResultSet rs= select.executeQuery(sql);
			while (rs.next()) {
				
				Time horaLlega, horaSale, tiempoEstimado;
				int hora, min, seg;
				
				InstanciaVueloBean instancia = new InstanciaVueloBeanImpl();
				AeropuertoBean aeropuertoLlegada = new AeropuertoBeanImpl();
				AeropuertoBean aeropuertoSalida = new AeropuertoBeanImpl();
								
				String sqlAeroLlegada = "SELECT * FROM aeropuertos WHERE codigo = '"+ rs.getString("codigo_aero_llega") + "'";
				
				
				String sqlAeroSalida = "SELECT * FROM aeropuertos WHERE codigo = '"+ rs.getString("codigo_aero_sale") + "'";
				
				Statement select2 = conexion.createStatement();
				Statement select3 = conexion.createStatement();
				
				ResultSet rsLlegada = select2.executeQuery(sqlAeroLlegada);
				
				ResultSet rsSalida = select3.executeQuery(sqlAeroSalida);
				
				//logger.debug(" anda"+rs.getString("nro_vuelo"));
				
				if(rsLlegada.next()) {
					aeropuertoLlegada.setCodigo(rsLlegada.getString("codigo"));
					aeropuertoLlegada.setDireccion(rsLlegada.getString("direccion"));
					aeropuertoLlegada.setNombre(rsLlegada.getString("nombre"));
					aeropuertoLlegada.setTelefono(rsLlegada.getString("telefono"));
					aeropuertoLlegada.setUbicacion(destino);
				}else {
					logger.debug("error en rsLlegada");
				}
				if(rsSalida.next()) {
					aeropuertoSalida.setCodigo(rsSalida.getString("codigo"));
					aeropuertoSalida.setDireccion(rsSalida.getString("direccion"));
					aeropuertoSalida.setNombre(rsSalida.getString("nombre"));
					aeropuertoSalida.setTelefono(rsSalida.getString("telefono"));
					aeropuertoSalida.setUbicacion(origen);
				}else {
					logger.debug("error en rsSalida");
				}
				
				instancia.setAeropuertoLlegada(aeropuertoLlegada);
				instancia.setAeropuertoSalida(aeropuertoSalida);
				
				//hh:mm:ss
				hora = Integer.parseInt((rs.getString("hora_llega")).substring(0, 2)); 
				min = Integer.parseInt((rs.getString("hora_llega")).substring(3, 5));
				seg = Integer.parseInt((rs.getString("hora_llega")).substring(6, 8));
				
				horaLlega = new Time(hora, min, seg);
				
				hora = Integer.parseInt((rs.getString("hora_sale")).substring(0, 2)); 
				min = Integer.parseInt((rs.getString("hora_sale")).substring(3, 5));
				seg = Integer.parseInt((rs.getString("hora_sale")).substring(6, 8));
				
				horaSale = new Time(hora, min, seg);

				hora = Integer.parseInt((rs.getString("tiempo_estimado")).substring(0, 2)); 
				min = Integer.parseInt((rs.getString("tiempo_estimado")).substring(3, 5));
				seg = Integer.parseInt((rs.getString("tiempo_estimado")).substring(6, 8));
				tiempoEstimado = new Time(hora, min, seg);
				
				instancia.setDiaSalida(rs.getString("dia_sale"));
				instancia.setFechaVuelo(rs.getDate("fecha"));
				instancia.setHoraLlegada(horaLlega);
				instancia.setHoraSalida(horaSale);
				instancia.setModelo(rs.getString("modelo"));
				instancia.setNroVuelo(rs.getString("nro_vuelo"));
				instancia.setTiempoEstimado(tiempoEstimado);
				
				resultado.add(instancia);
			}
		} catch (SQLException ex) {
			logger.error("SQLException: " + ex.getMessage());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error inesperado al consultar la B.D."); // propaga la excepción
		}
		
		
		return resultado;
	}

	@Override
	public ArrayList<DetalleVueloBean> recuperarDetalleVuelo(InstanciaVueloBean vuelo) throws Exception {
		/** 
		 * TODO Debe retornar una lista de clases, precios y asientos disponibles de dicho vuelo.		   
		 *      Debe propagar una excepción si hay algún error en la consulta.    
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).
		 */
		// OK. Salvo lo de preguntas practica.txt
		String sqlClase;
		ArrayList<DetalleVueloBean> resultado = new ArrayList<DetalleVueloBean>();		
		try {
			
			// correccion parte 2
			String fechaCasteada;
			fechaCasteada = (vuelo.getFechaVuelo().getYear() + 1900) + "-" + (vuelo.getFechaVuelo().getMonth() + 1) + "-"
					+ (vuelo.getFechaVuelo().getDate()); //getDay obtiene el numero del dia de la semana, nosotros necesitamos el numero del dia pero del mes
			
			sqlClase = "SELECT * FROM vuelos_disponibles WHERE nro_vuelo = '"+vuelo.getNroVuelo()+"' and fecha='"+fechaCasteada+"'";
			Statement select = conexion.createStatement();
			ResultSet rs= select.executeQuery(sqlClase);
			
			while(rs.next()) {
				DetalleVueloBeanImpl detalle = new DetalleVueloBeanImpl();
				detalle.setVuelo(vuelo);
				detalle.setPrecio(Float.parseFloat(rs.getString("precio")));
				detalle.setClase(rs.getString("clase"));
				detalle.setAsientosDisponibles(Integer.parseInt(rs.getString("asientos_disponibles")));
				resultado.add(detalle);
			}
			
		}catch(SQLException ex) {
			logger.error("SQLException: " + ex.getMessage());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error inesperado al consultar la B.D."); // propaga la excepción
		}
		
		
		return resultado; 
	}
}
