package py.com.flextech.utils.conversor;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

import org.springframework.stereotype.Component;

@Component
public class NumberFormatter {
	
    public static String convertirAGuaranies(BigDecimal monto) {
    	if(monto == null) {
    		return "";
    	}
        // Establecer la configuración local para Paraguay (Español, Guaraní)
        Locale locale = new Locale("es", "PY");

        // Crear un formato de número sin el símbolo de la moneda
        NumberFormat formatoNumero = NumberFormat.getNumberInstance(locale);

        // Formatear el BigDecimal como una cadena sin el símbolo de la moneda
        return formatoNumero.format(monto);
    }
}