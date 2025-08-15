package py.com.flextech.service.sistema;

import java.util.*;
import java.util.concurrent.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class EmailQueueService {

    private final BlockingQueue<CorreoPendiente> queue = new LinkedBlockingQueue<>();
    private final ExecutorService consumer = Executors.newSingleThreadExecutor();

    @Autowired
    private EmailService emailService;

    @jakarta.annotation.PostConstruct
    public void iniciarProcesador() {
        consumer.submit(this::loopProcesador);
    }

    private void loopProcesador() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                CorreoPendiente c = queue.take();

                // Si querés throttling entre envíos (p.ej. 300ms):
                // Thread.sleep(300);

                emailService.enviaEmailConAdjunto(
                        c.para, c.cc, c.bcc,
                        c.titulo, c.adjunto, c.model, c.template
                );
            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
            } catch (Exception e) {
                // TODO: logger adecuado
                e.printStackTrace();
            }
        }
    }

    // ---- Overloads públicos ----

    // Compatibilidad hacia atrás: un solo destino
    public void encolarEnvio(String destino,
                             String titulo,
                             MultipartFile adjunto,
                             Map<String, String> model,
                             String template) {

        encolarEnvio(Collections.singletonList(destino), Collections.emptyList(), Collections.emptyList(),
                titulo, adjunto, model, template);
    }

    // Lista de "para" (sin cc/bcc)
    public void encolarEnvio(Collection<String> para,
                             String titulo,
                             MultipartFile adjunto,
                             Map<String, String> model,
                             String template) {

        encolarEnvio(para, Collections.emptyList(), Collections.emptyList(),
                titulo,  adjunto, model, template);
    }

    // Varargs de "para"
    public void encolarEnvio(String titulo,
                             MultipartFile adjunto,
                             Map<String, String> model,
                             String template,
                             String... para) {

        encolarEnvio(Arrays.asList(para), Collections.emptyList(), Collections.emptyList(),
                titulo, adjunto, model, template);
    }

    // Completo: para, cc, bcc
    public void encolarEnvio(Collection<String> para,
                             Collection<String> cc,
                             Collection<String> bcc,
                             String titulo,
                             MultipartFile adjunto,
                             Map<String, String> model,
                             String template) {

        queue.add(new CorreoPendiente(
                safeList(para), safeList(cc), safeList(bcc),
                titulo, adjunto, model, template
        ));
    }

    private static List<String> safeList(Collection<String> in) {
        if (in == null) return Collections.emptyList();
        // Limpieza básica: trim + descartar vacíos + dedup
        LinkedHashSet<String> set = new LinkedHashSet<>();
        for (String s : in) {
            if (s != null) {
                String t = s.trim();
                if (!t.isEmpty()) set.add(t);
            }
        }
        return new ArrayList<>(set);
    }

    private record CorreoPendiente(
            List<String> para,
            List<String> cc,
            List<String> bcc,
            String titulo,
            MultipartFile adjunto,
            Map<String, String> model,
            String template
    ) {}
}
