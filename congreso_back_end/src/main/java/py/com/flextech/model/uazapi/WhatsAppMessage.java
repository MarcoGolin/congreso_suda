package py.com.flextech.model.uazapi;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Getter
@Setter
public class WhatsAppMessage {
    private String number;
    private TextMessage textMessage;
}