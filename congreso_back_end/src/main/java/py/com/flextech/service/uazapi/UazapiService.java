package py.com.flextech.service.uazapi;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import lombok.RequiredArgsConstructor;
import py.com.flextech.model.uazapi.TextMessage;
import py.com.flextech.model.uazapi.WhatsAppMessage;
import py.com.flextech.model.uazapi.WhatsAppMessageV2;

@Service
@RequiredArgsConstructor
public class UazapiService {

	private static final Logger logger = LoggerFactory.getLogger(UazapiService.class);
    private final WebClient webClient;


    public String sendMessage(String phoneNumber, String message) {
        logger.info("Enviando mensaje a: {}", phoneNumber);

        try {
            String response = webClient.post()
                .uri("/message/sendText/SORTEO_MILLONARIO")
                .bodyValue(new WhatsAppMessage(phoneNumber,new TextMessage(message)))
                .retrieve()
                .bodyToMono(String.class)
                .block();  // 🔴 Espera la respuesta y evita que el Mono sea ignorado
        
            logger.info("Respuesta de la API: {}", response);
            return response;
        
        } catch (WebClientResponseException ex) {
            logger.error("Error en la respuesta de la API: {} - {}", ex.getStatusCode(), ex.getResponseBodyAsString());
        } catch (Exception ex) {
            logger.error("Error inesperado al enviar mensaje: {}", ex.getMessage(), ex);
        }
        return null;
    }

    public String sendMessageV2(String phoneNumber, String message) {
    	logger.info("Enviando mensaje a: {}", phoneNumber);
    	
    	try {
    		String response = webClient.post()
    				.uri("/send/text")
    				.header("token", "214f7815-71f6-40cb-b4e9-2d668abd98b6")
    				.bodyValue(new WhatsAppMessageV2(phoneNumber,message, true))
    				.retrieve()
    				.bodyToMono(String.class)
    				.block();  // 🔴 Espera la respuesta y evita que el Mono sea ignorado
    		
    		logger.info("Respuesta de la API: {}", response);
    		return response;
    		
    	} catch (WebClientResponseException ex) {
    		logger.error("Error en la respuesta de la API: {} - {}", ex.getStatusCode(), ex.getResponseBodyAsString());
    	} catch (Exception ex) {
    		logger.error("Error inesperado al enviar mensaje: {}", ex.getMessage(), ex);
    	}
    	return null;
    }
}