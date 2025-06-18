package py.com.flextech.utils.database;


public class SQLUtils {
	
	public static String  like(String value) {
		if(value == null || value.isEmpty()) {
			return "'%%'";
		}
		return "'%"+value.toUpperCase()+"%'";
	}

}
