package persistencia;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import comunicacion.ActorDTO;
import excepciones.DAOExcepcion;

public class ActorDAO {
	
	private ConnectionManager connManager;


	public ActorDAO(ConnectionManager connManager) throws ClassNotFoundException {
			this.connManager= connManager;//new ConnectionManager(database);
	}
	
	
	public ActorDTO buscarActorPorCod(String cod)	throws DAOExcepcion{
		try{
			String query = "";
			query = "SELECT * FROM ACTOR WHERE COD_ACT LIKE = '" + cod + "'";
			
			if (query.compareTo("")==0 || query.isEmpty()) return null;
			
			ResultSet rs=connManager.queryDB(query);
										
			if (rs.next())
				return new ActorDTO(rs.getString("COD_ACT"),rs.getString("NOMBRE"),rs.getDate("FECHA_NAC"),rs.getString("NOM_PAIS"));
	
			return null;
		}
		catch (Exception e){		throw new DAOExcepcion(e);}
	}
	
		

	public List<ActorDTO> buscarActores() throws DAOExcepcion{
		try{
			List<ActorDTO> listaActores=new ArrayList<ActorDTO>();
			
			String query = "";
			query = "SELECT * FROM ACTOR";
			
			if (query.compareTo("")==0 || query.isEmpty()) return listaActores;			
			
			ResultSet rs=connManager.queryDB(query);						
			
			try{				
				while (rs.next()){
					ActorDTO actor = new ActorDTO(rs.getString("COD_ACT"),rs.getString("NOMBRE"),rs.getDate("FECHA_NAC"),rs.getString("NOM_PAIS")); 
					listaActores.add(actor);
				}
				return listaActores;
			}
			catch (Exception e){	throw new DAOExcepcion(e);}
		}
		catch (DAOExcepcion e){		throw e;}	
	}
}
