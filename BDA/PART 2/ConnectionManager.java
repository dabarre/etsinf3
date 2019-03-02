package persistencia;
import java.sql.*;

import excepciones.DAOExcepcion;

public class ConnectionManager {

	private String sourceURL;
	private Connection dbconection=null;
	private String usuario;
	private String password;


	public ConnectionManager(String usuario, String password) throws ClassNotFoundException, SQLException{	
		//Se carga el driver JDBC
		DriverManager.registerDriver( new oracle.jdbc.driver.OracleDriver() );
		//nombre del servidor
		String nombre_servidor = "158.42.179.25";
		//numero del puerto
		String numero_puerto = "1521";
		//SID
		String sid = "labora";
		//Nombre usuario y password
        this.usuario = usuario;
        this.password = password;
		//URL "jdbc:oracle:thin:@nombreServidor:numeroPuerto:sid"
		sourceURL = "jdbc:oracle:thin:@" + nombre_servidor + ":" + numero_puerto + ":" + sid;
	}
	public void connect() throws DAOExcepcion{
		if (dbconection==null)
			try{
				//Obtiene la conexion
				dbconection = DriverManager.getConnection( sourceURL, usuario, password );
			} catch(SQLException e){
				throw new DAOExcepcion("DB_CONNECT_ERROR");
			}
	}
	public void close() throws DAOExcepcion{
		if (dbconection!=null){
			try{
				dbconection.close();
			} catch(SQLException e){
				throw new DAOExcepcion("DB_DISCONNECT_ERROR");
			}
			dbconection=null;
		}	
	}
	public void updateDB(String sql) throws DAOExcepcion{
		if (dbconection!=null){
			try{
				Statement sentencia = dbconection.createStatement();
				sentencia.executeUpdate(sql);
			} catch(SQLException e){
				throw new DAOExcepcion("DB_WRITE_ERROR");
			}
		}
	}
	public ResultSet queryDB(String sql) throws DAOExcepcion{
		if (dbconection!=null){
			try{
				Statement sentencia = dbconection.createStatement();
				return sentencia.executeQuery(sql);
			} catch(SQLException e){
				throw new DAOExcepcion("DB_READ_ERROR: "+sql);
			}
		}
		return null;
	}
}


