package py.com.flextech.utils.date;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import org.springframework.context.i18n.LocaleContextHolder;

public class DateUtils {

	public static String formatDateTime(LocalDateTime date, String offSet) {
		
		if(date == null) {
			return "";
		}
		Locale locale = LocaleContextHolder.getLocale();

		String pattern = "dd/MM/YYYY HH:mm";
		if (locale.getDisplayLanguage().contains("en")) {
			pattern = "yyy-MM-dd HH:mm";
		}
		LocalDateTime localDateTime = date.atZone(ZoneOffset.UTC).withZoneSameInstant(ZoneId.of("UTC"+offSet)).toLocalDateTime();
		
		String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(localDateTime);
		return dateFormatted;
	}
	public static String formatDateSQL(LocalDateTime date) {
		
		if(date == null) {
			return "";
		}
		String pattern = "YYYY-MM-dd";
		String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
		return dateFormatted;
	}

	public static String formatDate(LocalDateTime date) {
		
		if(date == null) {
			return "";
		}
		String pattern = "dd/MM/YYYY";
		String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
		return dateFormatted;
	}
	
public static String formatOnlyDate(LocalDate date) {
		
		if(date == null) {
			return "";
		}
		String pattern = "dd/MM/YYYY";
		String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
		return dateFormatted;
	}
	
	public static String formatDate(LocalDate date, String offSet) {
		Locale locale = LocaleContextHolder.getLocale();
		String pattern = "dd/MM/YYYY";
		if (locale.getDisplayLanguage().contains("en")) {
			pattern = "yyy-MM-dd";
		}
		String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
		return dateFormatted;
	}

	public static String formatDateddMMYY(LocalDate date, String offSet) {
		Locale locale = LocaleContextHolder.getLocale();
		String pattern = "dd/MM/YY";
		if (locale.getDisplayLanguage().contains("en")) {
			pattern = "yyy-MM-dd";
		}
		String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
		return dateFormatted;
	}
	
	   public static String formatDateDiaMesAñoLetras(LocalDateTime date) {
	        if (date == null) {
	            return "";
	        }
	        String pattern = "EEEE, dd 'de' MMMM 'del' yyyy";
	        String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
	        dateFormatted = dateFormatted.substring(0, 1).toUpperCase() + dateFormatted.substring(1);
	        return dateFormatted;
	    }

		public static String formatOutputHora(LocalDateTime date) {
			
			if(date == null) {
				return "";
			}
			String pattern = "hh:mm a";
			String dateFormatted = DateTimeFormatter.ofPattern(pattern).format(date);
			return dateFormatted;
		}
}
