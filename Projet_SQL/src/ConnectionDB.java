import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {

	
	public static Connection initConnection(){
		
		Connection conn = null;
		
		try{
			Class.forName("org.postgresql.Driver");
		}catch(ClassNotFoundException e){
			System.out.println("Erreur. Driver postgres manquant !");
			e.printStackTrace();
			System.exit(0);
		}
		System.out.println("Driver OK");
		
		//To modify : ip, db, login, pwd
		String url = "jdbc:postgresql://localhost:5432/postgres";

		try{
			conn = DriverManager.getConnection(url, "postgres", "teampae02");
		}catch(SQLException e){
			System.out.println("Erreur. La connexion DB a echouée !");
			e.printStackTrace();
			System.exit(0);
		}
		
		System.out.println("Connexion DB OK");
		
		return conn;
		
	}
	
}
