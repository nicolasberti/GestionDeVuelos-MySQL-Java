package vuelos.modelo.empleado.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBean;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBeanImpl;
import vuelos.modelo.empleado.beans.PasajeroBean;
import vuelos.modelo.empleado.beans.ReservaBean;
import vuelos.modelo.empleado.beans.ReservaBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;

public class DAOReservaImpl implements DAOReserva {

	private static Logger logger = LoggerFactory.getLogger(DAOReservaImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOReservaImpl(Connection conexion) {
		this.conexion = conexion;
	}
		
	
	@Override
	public int reservarSoloIda(PasajeroBean pasajero, 
							   InstanciaVueloBean vuelo, 
							   DetalleVueloBean detalleVuelo,
							   EmpleadoBean empleado) throws Exception {
		logger.info("Realiza la reserva de solo ida con pasajero {}", pasajero.getNroDocumento());
		
		/**
		 * TODO (parte 2) Realizar una reserva de ida solamente llamando al Stored Procedure (S.P.) correspondiente. 
		 *      Si la reserva tuvo exito deberá retornar el número de reserva. Si la reserva no tuvo éxito o 
		 *      falla el S.P. deberá propagar un mensaje de error explicativo dentro de una excepción.
		 *      La demás excepciones generadas automáticamente por algun otro error simplemente se propagan.
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
		 *		
		 * 
		 * @throws Exception. Deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores
		 *		   pero luego deberá propagarla para que el controlador se encargue de manejarla.
		 *
		 */
		int resultado = 0;
		logger.debug("call reserva_vuelo_ida('"+vuelo.getNroVuelo()+"','"+vuelo.getFechaVuelo()+"','"+detalleVuelo.getClase()+"','"+pasajero.getTipoDocumento()+"',"+pasajero.getNroDocumento()+","+empleado.getLegajo()+")");
		try (CallableStatement cstmt = conexion.prepareCall("call reserva_vuelo_ida('"+vuelo.getNroVuelo()+"','"+vuelo.getFechaVuelo()+"','"+detalleVuelo.getClase()+"','"+pasajero.getTipoDocumento()+"',"+pasajero.getNroDocumento()+","+empleado.getLegajo()+")"))
		{
			cstmt.execute();
			ResultSet result = cstmt.getResultSet();
			result.next();
			resultado = Integer.parseInt(result.getString("resultado"));
			if(resultado <= 0) {
				switch(resultado) {
					case 0: throw new Exception("Se produjo un error al reservar el viaje."); 
					case -1: throw new Exception("Se produjo un error en la transacción."); 
					case -2: throw new Exception("No hay lugares disponibles en el viaje."); 
					case -3: throw new Exception("El viaje al cual se intenta registrar no existe."); 
				}
			}
		}
		catch (SQLException ex){
				logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		   		throw ex;
		} 
		logger.debug("reservarSoloIda retorna: "+resultado);
		return resultado;
	}
	
	@Override
	public int reservarIdaVuelta(PasajeroBean pasajero, 
				 				 InstanciaVueloBean vueloIda,
				 				 DetalleVueloBean detalleVueloIda,
				 				 InstanciaVueloBean vueloVuelta,
				 				 DetalleVueloBean detalleVueloVuelta,
				 				 EmpleadoBean empleado) throws Exception {
		
		logger.info("Realiza la reserva de ida y vuelta con pasajero {}", pasajero.getNroDocumento());
		/**
		 * TODO (parte 2) Realizar una reserva de ida y vuelta llamando al Stored Procedure (S.P.) correspondiente. 
		 *      Si la reserva tuvo exito deberá retornar el número de reserva. Si la reserva no tuvo éxito o 
		 *      falla el S.P. deberá propagar un mensaje de error explicativo dentro de una excepción.
		 *      La demás excepciones generadas automáticamente por algun otro error simplemente se propagan.
		 *      
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
		 * 
		 * @throws Exception. Deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores
		 *		   pero luego deberá propagarla para que se encargue el controlador.
		*/
		
		int resultado = 0;
		logger.debug("call reserva_vuelo_ida_vuelta('"+vueloIda.getNroVuelo()+"','"+vueloVuelta.getNroVuelo()+"','"+vueloIda.getFechaVuelo()+"','"+vueloVuelta.getFechaVuelo()+"','"+detalleVueloIda.getClase()+"','"+detalleVueloVuelta.getClase()+"','"+pasajero.getTipoDocumento()+"',"+pasajero.getNroDocumento()+","+empleado.getLegajo()+")");
		try (CallableStatement cstmt = conexion.prepareCall("call reserva_vuelo_ida_vuelta('"+vueloIda.getNroVuelo()+"','"+vueloVuelta.getNroVuelo()+"','"+vueloIda.getFechaVuelo()+"','"+vueloVuelta.getFechaVuelo()+"','"+detalleVueloIda.getClase()+"','"+detalleVueloVuelta.getClase()+"','"+pasajero.getTipoDocumento()+"',"+pasajero.getNroDocumento()+","+empleado.getLegajo()+")"))
		{
			cstmt.execute();
			ResultSet result = cstmt.getResultSet();
			result.next();
			resultado = Integer.parseInt(result.getString("resultado"));
			if(resultado <= 0) {
				switch(resultado) {
					case 0: throw new Exception("Se produjo un error al reservar el viaje."); 
					case -1: throw new Exception("Se produjo un error en la transacción."); 
					case -2: throw new Exception("No hay lugares disponibles para el viaje de vuelta."); 
					case -3: throw new Exception("No hay lugares disponibles para el viaje de ida.");
					case -4: throw new Exception("Alguno de los viajes no existe.");
				}
			}
		}
		catch (SQLException ex){
				logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		   		throw ex;
		} 
		logger.debug("reservarIdaVuelta retorna: "+resultado);
		return resultado;
		
	}
	
	@Override
	public ReservaBean recuperarReserva(int codigoReserva) throws Exception {
		
		logger.info("Solicita recuperar información de la reserva con codigo {}", codigoReserva);
		
		/**
		 * TODO (parte 2) Debe realizar una consulta que retorne un objeto ReservaBean donde tenga los datos de la
		 *      reserva que corresponda con el codigoReserva y en caso que no exista generar una excepción.
		 *
		 * 		Debe poblar la reserva con todas las instancias de vuelo asociadas a dicha reserva y 
		 * 		las clases correspondientes.
		 * 
		 * 		Los objetos ReservaBean además de las propiedades propias de una reserva tienen un arraylist
		 * 		con pares de instanciaVuelo y Clase. Si la reserva es solo de ida va a tener un unico
		 * 		elemento el arreglo, y si es de ida y vuelta tendrá dos elementos. 
		 * 
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
		 */
		
		
		ReservaBean reserva = null;
		try {
			String sql= "SELECT * FROM reservas WHERE numero="+codigoReserva+"";
			Statement select = conexion.createStatement();
			ResultSet rs= select.executeQuery(sql);
			
			if(rs.next()) {
				reserva = new ReservaBeanImpl();
				reserva.setNumero(codigoReserva);
				reserva.setFecha(rs.getDate("fecha"));
				reserva.setVencimiento(rs.getDate("vencimiento"));
				reserva.setEstado(rs.getString("estado"));
				
				DAOPasajero dao = new DAOPasajeroImpl(this.conexion);
				PasajeroBean pasajero = dao.recuperarPasajero(rs.getString("doc_tipo"), rs.getInt("doc_nro"));
				reserva.setPasajero(pasajero);
				
				DAOEmpleado dao2 = new DAOEmpleadoImpl(this.conexion);
				EmpleadoBean empleado = dao2.recuperarEmpleado(rs.getInt("legajo"));
				reserva.setEmpleado(empleado);
	
				ArrayList<InstanciaVueloClaseBean> vuelosClase =  new ArrayList<InstanciaVueloClaseBean>();  
				reserva.setVuelosClase(vuelosClase);
				
				String sqlIVC = "select * from (select nro_vuelo as vuelo, fecha, clase, ciudad_sale, estado_sale, pais_sale, ciudad_llega, estado_llega, pais_llega from vuelos_disponibles) C NATURAL JOIN (select * from (select numero, vuelo, fecha_vuelo as fecha, clase from reserva_vuelo_clase where numero="+codigoReserva+") B NATURAL JOIN (select * from instancias_vuelo) A) D";
				Statement selectIVC = conexion.createStatement();
				ResultSet rsIVC= selectIVC.executeQuery(sqlIVC);
				
				while(rsIVC.next()) {
					
					UbicacionesBean origen = new UbicacionesBeanImpl();
					String sqlORI= "SELECT * FROM ubicaciones WHERE pais='"+rsIVC.getString("pais_sale")+"' and ciudad='"+rsIVC.getString("ciudad_sale")+"' and estado='"+rsIVC.getString("estado_sale")+"'";
					Statement selectORI = conexion.createStatement();
					ResultSet rsORI= selectORI.executeQuery(sqlORI);
					rsORI.next();
					origen.setCiudad(rsORI.getString("ciudad"));
					origen.setEstado(rsORI.getString("estado"));
					origen.setPais(rsORI.getString("pais"));
					origen.setHuso(rsORI.getInt("huso"));
					
					UbicacionesBean destino = new UbicacionesBeanImpl();
					String sqlDES= "SELECT * FROM ubicaciones WHERE pais='"+rsIVC.getString("pais_llega")+"' and ciudad='"+rsIVC.getString("ciudad_llega")+"' and estado='"+rsIVC.getString("estado_llega")+"'";
					Statement selectDES = conexion.createStatement();
					ResultSet rsDES= selectDES.executeQuery(sqlDES);
					rsDES.next();
					destino.setCiudad(rsDES.getString("ciudad"));
					destino.setEstado(rsDES.getString("estado"));
					destino.setPais(rsDES.getString("pais"));
					destino.setHuso(rsDES.getInt("huso"));
					
					DAOVuelos daoV = new DAOVuelosImpl(this.conexion);
					ArrayList<InstanciaVueloBean> instanciasVuelo = daoV.recuperarVuelosDisponibles(rsIVC.getDate("fecha"), origen, destino);
					
					InstanciaVueloClaseBean instancia = new InstanciaVueloClaseBeanImpl();
					instancia.setVuelo(instanciasVuelo.get(0));
					instancia.setClase( daoV.recuperarDetalleVuelo(instanciasVuelo.get(0)).get(0));
					vuelosClase.add(instancia);
					
				}
				if(vuelosClase.size() == 2)
					reserva.setEsIdaVuelta(true);
				else reserva.setEsIdaVuelta(false);
				
				logger.debug("Se recuperó la reserva: {}, {}", reserva.getNumero(), reserva.getEstado());
			} else { throw new Exception("No existe la reserva."); }//excepcion
		} catch (SQLException ex)
		{
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error inesperado al consultar la B.D."); // propaga la excepción
		}
		return reserva;
		
	}
	

}
