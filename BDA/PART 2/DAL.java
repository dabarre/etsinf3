package persistencia;
import java.sql.SQLException;
import java.util.*;

import comunicacion.*;
import excepciones.*;


public class DAL {
	//private static DAL dal;
	private PeliculaDAO peliculaDAO;
	private LibroDAO libroDAO;
	private ActorDAO actorDAO;
	private ActuaDAO actuaDAO;
	private ConnectionManager connManager;
	
	
	public DAL(String usuario, String password) throws DAOExcepcion{
		
		
		//****************************************************************
		//****  OBJETOS PARA COMUNICARSE CON LA CAPA DE ACCESO A DATOS
		//****************************************************************

		try {
			connManager = new ConnectionManager(usuario, password);
			peliculaDAO =  new PeliculaDAO(connManager);
			libroDAO =  new LibroDAO(connManager);
			actorDAO =  new ActorDAO(connManager);
			actuaDAO =  new ActuaDAO(connManager);
		} catch (ClassNotFoundException | SQLException e) {
			throw new DAOExcepcion(e.getMessage());
		}
		
	}
	
	//****************************************************************
	//****     CONEXIÓN/DESCONEXIÓN
	//****************************************************************
	public boolean probarConexion() throws DAOExcepcion {
		try {
			connManager.connect();
			//connManager.close();
			return true;
		} catch (Exception e) {
			throw new DAOExcepcion(e.getMessage());
		}
	}
	public boolean desconectar() throws DAOExcepcion {
		try {
			connManager.close();
			return true;
		} catch (Exception e) {
			throw new DAOExcepcion(e.getMessage());
		}
	}



	
//	//****************************************************************
//	//****     PATRON SINGLETON
//	//****************************************************************
//	
//	public static DAL dameDAL() throws DAOExcepcion{
//		if (dal==null)
//			dal = new DAL("BaseDeDatos");
//		return dal;
//	}
//	
//	
	//****************************************************************
	//****     PELICULAS
	//****************************************************************
	public List<PeliculaDTO> buscarPeliculas() throws DAOExcepcion{
		return peliculaDAO.buscarPeliculas();
	}
	
	public PeliculaDTO buscarPeliculaPorCod(String cod) throws DAOExcepcion{
		return peliculaDAO.buscarPeliculaPorCod(cod);
	}
	

	public void crearPelicula(PeliculaDTO peli) throws DAOExcepcion{
		peliculaDAO.crearPelicula(peli);
	}
	
	//****************************************************************
	//****     LIBROS
	//****************************************************************
	public List<LibroDTO> buscarLibros() throws DAOExcepcion{
		return libroDAO.buscarLibros();
	}
	
	public LibroDTO buscarLibroPorCod(String cod) throws DAOExcepcion{
		return libroDAO.buscarLibroPorCod(cod);
	}
	
	//****************************************************************
	//****     ACTORES
	//****************************************************************
	public List<ActorDTO> buscarActores() throws DAOExcepcion{
		return actorDAO.buscarActores();
	}
	
	public ActorDTO buscarActorPorCod(String cod) throws DAOExcepcion{
		return actorDAO.buscarActorPorCod(cod);
	}
	
	public List<ActorDTO> buscarActoresPorCodPeli(String cod) throws DAOExcepcion{
		List<ActuaDTO> listaActuaciones = actuaDAO.buscarActuaPorCodPeli(cod);
		List<ActorDTO> listaActores = new ArrayList<ActorDTO>();
		for(ActuaDTO actua : listaActuaciones)
			listaActores.add(buscarActorPorCod(actua.getCod_act()));
		
		return listaActores;
	}

	public ActuaDTO buscarActuacionPorPeliActor(String cod_peli, String cod_act) throws DAOExcepcion {
		// TODO Auto-generated method stub
		return actuaDAO.buscarActuacionPorPeliActor(cod_peli, cod_act);
	}

	public void crearActuacion(ActuaDTO actua) throws DAOExcepcion {
		// TODO Auto-generated method stub
		actuaDAO.crearActuacion(actua);
	}
	
}
