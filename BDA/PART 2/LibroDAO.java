package persistencia;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import comunicacion.LibroDTO;
import excepciones.DAOExcepcion;



public class LibroDAO {
	
	private ConnectionManager connManager;


	public LibroDAO(ConnectionManager connManager) throws ClassNotFoundException {
			this.connManager= connManager;
	}
	
	
	public LibroDTO buscarLibroPorCod(String cod)	throws DAOExcepcion{
		try{
			String query = "";
			
			if (query.compareTo("")==0 || query.isEmpty()) return null;
			
			query = "SELECT * FROM LIBRO WHERE COD_LIB LIKE = '" + cod + "'";
			
			ResultSet rs=connManager.queryDB(query);
				
			if (rs.next())
				return new LibroDTO(rs.getString("COD_LIB"),rs.getString("TITULO"),rs.getInt("ANYO"),rs.getString("AUTOR"));
	
			return null;
		}
		catch (Exception e){		throw new DAOExcepcion(e);}
	}
	
		

	public List<LibroDTO> buscarLibros() throws DAOExcepcion{
		try{
			List<LibroDTO> listaLibros=new ArrayList<LibroDTO>();
			String query = "";
			query = "SELECT * FROM LIBRO";
			
			if (query.compareTo("")==0 || query.isEmpty()) return listaLibros;

			
			ResultSet rs=connManager.queryDB(query);						
			
			try{				
				while (rs.next()){
					LibroDTO actor = new LibroDTO(rs.getString("COD_LIB"),rs.getString("TITULO"),rs.getInt("ANYO"),rs.getString("AUTOR")); 
					listaLibros.add(actor);
				}
				return listaLibros;
			}
			catch (Exception e){	throw new DAOExcepcion(e);}
		}
		catch (DAOExcepcion e){		throw e;}	
	}

}
