package py.com.flextech.service.sistema;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.multipart.MultipartFile;

import freemarker.core.ParseException;
import freemarker.template.Configuration;
import freemarker.template.MalformedTemplateNameException;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateNotFoundException;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class EmailService {

	final private JavaMailSender sender;
	final private Configuration config;
	@Value("${spring.mail.username}")
	private String sendEmailUser;

	public void enviaEmailConAdjunto(String destino, 
			String titulo, 
			String nombre, 
			MultipartFile pdfFile,
			Map<String, String> model,
			String template)
	        throws MessagingException, TemplateNotFoundException, MalformedTemplateNameException, ParseException,
	        IOException, TemplateException, InterruptedException {

	    MimeMessage message = sender.createMimeMessage();
	    
	    message.addHeader("X-Priority", "1");
	    message.addHeader("X-Mailer", "JavaMail");
	    message.addHeader("Disposition-Notification-To", sendEmailUser);

	    MimeMessageHelper helper = new MimeMessageHelper(message, MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
	            StandardCharsets.UTF_8.name());

	    Template t = config.getTemplate(template);
	    String html = FreeMarkerTemplateUtils.processTemplateIntoString(t, model);
	    
	    // Configurar el correo
	    helper.setTo(destino);
	    helper.setText(html, true);
	    helper.setSubject(titulo);
	    helper.setFrom("cusmienvios2@flextech.com.py", "Congreso Sudamericana 2025");

	    // Adjuntar el archivo PDF
	    if (pdfFile != null && !pdfFile.isEmpty()) {
	        helper.addAttachment(pdfFile.getOriginalFilename(), pdfFile);
	    }

	    // Enviar el correo
	    sender.send(message);
	}

}