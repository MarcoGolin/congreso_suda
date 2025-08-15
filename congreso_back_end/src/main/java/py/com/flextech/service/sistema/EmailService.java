package py.com.flextech.service.sistema;

import java.util.Collection;
import java.util.Map;
import org.springframework.web.multipart.MultipartFile;

public interface EmailService {

    // Método existente (si ya lo tenés)
    void enviaEmailConAdjunto(String destino,
                              String titulo,
                              MultipartFile adjunto,
                              Map<String, String> model,
                              String template);

    // Nuevo: múltiples destinatarios + CC/BCC
    void enviaEmailConAdjunto(Collection<String> para,
                              Collection<String> cc,
                              Collection<String> bcc,
                              String titulo,
                              MultipartFile adjunto,
                              Map<String, String> model,
                              String template);
}
