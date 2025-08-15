package py.com.flextech.service.sistema;

import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.lang.Nullable;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.multipart.MultipartFile;

import freemarker.template.Configuration;
import freemarker.template.Template;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender;
    
    @Autowired 
    private Configuration freemarkerConfig;

    @Override
    public void enviaEmailConAdjunto(String destino,
                                     String titulo,
                                     MultipartFile adjunto,
                                     Map<String, String> model,
                                     String template) {
        enviaEmailConAdjunto(java.util.List.of(destino), java.util.List.of(), java.util.List.of(),
                titulo,  adjunto, model, template);
    }

    @Override
    public void enviaEmailConAdjunto(Collection<String> para,
                                     Collection<String> cc,
                                     Collection<String> bcc,
                                     String titulo,
                                     @Nullable MultipartFile adjunto,
                                     Map<String, String> model,
                                     String templateHtml) {
        try {
            jakarta.mail.internet.MimeMessage mime = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mime, true, StandardCharsets.UTF_8.name());
            
            Template template = freemarkerConfig.getTemplate(templateHtml, "UTF-8");
            String html = FreeMarkerTemplateUtils.processTemplateIntoString(template, model);

            // From configurable (application.yml)
            helper.setFrom("noresponder@congresounisud.com", "IV CUSMI 2025");

            if (para != null && !para.isEmpty()) {
                helper.setTo(para.toArray(String[]::new));
            } else {
                throw new IllegalArgumentException("Lista de destinatarios 'para' vacía.");
            }
            if (cc != null && !cc.isEmpty()) helper.setCc(cc.toArray(String[]::new));
            if (bcc != null && !bcc.isEmpty()) helper.setBcc(bcc.toArray(String[]::new));

            helper.setSubject(titulo);

            // Si usás plantilla HTML, acá deberías hacer el render con tu motor (Thymeleaf, FreeMarker, etc).
            // Por simplicidad, asumimos que 'templateHtml' YA VIENE renderizado con variables.
            helper.setText(html, true);

            if (adjunto != null && !adjunto.isEmpty()) {
                helper.addAttachment(
                        adjunto.getOriginalFilename() != null ? adjunto.getOriginalFilename() : "archivo",
                        new ByteArrayResource(adjunto.getBytes())
                );
            }

            mailSender.send(mime);
        } catch (Exception e) {
            // TODO: logger + retry policy si corresponde
            throw new RuntimeException("Error enviando correo: " + e.getMessage(), e);
        }
    }
}
