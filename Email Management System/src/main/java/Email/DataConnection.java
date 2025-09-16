package Email;
import java.sql.*;
public class DataConnection {

	public static Connection getCon() {
	  Connection con=null;
     try
     {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","system","0900");
     }
     catch(Exception e)
     {
         System.out.println(e);
     }
		
		return con;
	}
	
}
