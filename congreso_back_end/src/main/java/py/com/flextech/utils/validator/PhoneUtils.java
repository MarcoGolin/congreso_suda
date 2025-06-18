package py.com.flextech.utils.validator;

public class PhoneUtils {
	
	public static boolean isValid(String phone) {
		if(phone.length() == 10) {
			return true;
		}
		return false;
	}
	
	
	public static String convertTo595(String phone) {
		String converted = "595" + phone.subSequence(1, phone.length());
		
		return converted.trim();
	}

}