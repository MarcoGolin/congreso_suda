package py.com.flextech.service.sistema;

import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class EmailQueueService {

    private final BlockingQueue<CorreoPendiente> queue = new LinkedBlockingQueue<>();
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    @Autowired
    private EmailService emailService; // Tu clase que envía emails reales

    @jakarta.annotation.PostConstruct
    public void iniciarProcesador() {
        scheduler.scheduleWithFixedDelay(this::procesarCola, 0, 45, TimeUnit.SECONDS); // delay ajustable
    }

    private void procesarCola() {
        try {
            CorreoPendiente correo = queue.take();
            emailService.enviaEmailConAdjunto(
                correo.destino,
                correo.titulo,
                correo.nombre,
                correo.adjunto,
                correo.model,
                correo.template
            );
        } catch (Exception e) {
            e.printStackTrace(); // log adecuado aquí
        }
    }

    public void encolarEnvio(String destino, String titulo, String nombre, MultipartFile adjunto, Map<String, String> model, String template) {
        queue.add(new CorreoPendiente(destino, titulo, nombre, adjunto, model, template));
    }

    private record CorreoPendiente(
            String destino,
            String titulo,
            String nombre,
            MultipartFile adjunto,
            Map<String, String> model,
            String template
    ) {}
}
