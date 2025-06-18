package py.com.flextech.utils.generator;

import java.security.SecureRandom;

public class CodigoActivacionGenerator {
    private static final String CARACTERES = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int LONGITUD = 16; // puedes ajustar
    private static final SecureRandom random = new SecureRandom();

    public static String generarCodigo() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < LONGITUD; i++) {
            if (i > 0 && i % 4 == 0) sb.append("-");
            sb.append(CARACTERES.charAt(random.nextInt(CARACTERES.length())));
        }
        return sb.toString();
    }

}