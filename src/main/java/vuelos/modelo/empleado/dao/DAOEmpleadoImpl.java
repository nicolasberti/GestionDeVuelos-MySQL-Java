package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.EmpleadoBeanImpl;

public class DAOEmpleadoImpl implements DAOEmpleado {

	private static Logger logger = LoggerFactory.getLogger(DAOEmpleadoImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOEmpleadoImpl(Connection c) {
		this.conexion = c;
	}


	@Override
	public EmpleadoBean recuperarEmpleado(int legajo) throws Exception {
		logger.info("recupera el empleado que corresponde al legajo {}.", legajo);
		
		/**
		 * TODO Debe recuperar de la B.D. los datos del empleado que corresponda al legajo pasado 
		 *      como parámetro y devolver los datos en un objeto EmpleadoBean. Si no existe el legajo 
		 *      deberá retornar null y si ocurre algun error deberá generar y propagar una excepción.	
		 *       
		 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
		 *      establecida con el servidor de B.D. (inicializada en el constructor DAOEmpleadoImpl(...)). 
		 */		
		// OK -> Preguntar algunas cosas.	
		EmpleadoBean empleado = null;
		try {
		String sql= "SELECT * FROM empleados WHERE legajo="+legajo+"";
		
		Statement select = conexion.createStatement();
		ResultSet rs= select.executeQuery(sql);
		rs.next();
		empleado = new EmpleadoBeanImpl();
		empleado.setLegajo(Integer.parseInt(rs.getString("legajo")));
		empleado.setApellido(rs.getString("apellido"));
		empleado.setNombre(rs.getString("nombre"));
		empleado.setTipoDocumento(rs.getString("doc_tipo"));
		empleado.setNroDocumento(Integer.parseInt(rs.getString("doc_nro")));
		empleado.setDireccion(rs.getString("direccion"));
		empleado.setTelefono(rs.getString("telefono"));
		empleado.setCargo(""); // ¿? Preguntar. -> Dijeron que lo dejemos como string vacío.
		empleado.setPassword(rs.getString("password"));
		empleado.setNroSucursal(0); // ¿? Preguntar -> Dijeron que lo dejemos como vacío (i.e 0)
		} catch (SQLException ex)
		{
			logger.error("SQLException: " + ex.getMessage());
			logger.error("SQLState: " + ex.getSQLState());
			logger.error("VendorError: " + ex.getErrorCode());
			throw new Exception("Error inesperado al consultar la B.D."); // propaga la excepción
		}
		return empleado;
	}

}
