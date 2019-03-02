package persistencia;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import comunicacion.PeliculaDTO;
import excepciones.DAOExcepcion;



public class PeliculaDAO {
	
	private ConnectionManager connManager;


	public PeliculaDAO(ConnectionManager connManager) throws ClassNotFoundException {
			this.connManager= connManager;
	}
	
	
	public PeliculaDTO buscarPeliculaPorCod(String cod)	throws DAOExcepcion{
		try{
			String query = "";
			query = "SELECT * FROM PELICULA WHERE COD_PELI = '" + cod + "'";
			
			if (query.compareTo("")==0 || query.isEmpty()) return null;			
			
			ResultSet rs=connManager.queryDB(query);
			
				
			if (rs.next())
				return new PeliculaDTO(rs.getString("COD_PELI"),rs.getString("TITULO"),rs.getString("ANYO"),rs.getInt("DURACION"),rs.getString("COD_LIB"),rs.getString("DIRECTOR"));
	
			return null;
		}
		catch (Exception e){		throw new DAOExcepcion(e);}
	}
	
		
	public void crearPelicula(PeliculaDTO peli) throws DAOExcepcion {
		try{
			String query = "";			
			query = "INSERT INTO PELICULA VALUES (" + "'" + peli.getCod_peli() + "',"
					+ "'" + peli.getTitulo() + "'," + "'" + peli.getAnyo() + "',"
					+ "'" + peli.getDuracion() + "'," + "'" + peli.getDirector() + "')";
			
			if (query.compareTo("")==0 || query.isEmpty()) return;
			
			connManager.updateDB(query);
			
		}
		catch (Exception e){		throw new DAOExcepcion(e);}
	}

 

	public List<PeliculaDTO> buscarPeliculas() throws DAOExcepcion{
		try{
			List<PeliculaDTO> listaPeliculas=new ArrayList<PeliculaDTO>();
			String query = "";
			query = "SELECT * FROM PELICULA";
			
			if (query.compareTo("")==0 || query.isEmpty()) return listaPeliculas;			
			
			ResultSet rs=connManager.queryDB(query);						
				
			try{				
				while (rs.next()){
					PeliculaDTO peli = new PeliculaDTO(rs.getString("COD_PELI"),rs.getString("TITULO"),rs.getString("ANYO"),rs.getInt("DURACION"),rs.getString("COD_LIB"),rs.getString("DIRECTOR")); 
					listaPeliculas.add(peli);
				}
				return listaPeliculas;
			}
			catch (Exception e){	throw new DAOExcepcion(e);}
		}
		catch (DAOExcepcion e){		throw e;}	
	}
		
}
