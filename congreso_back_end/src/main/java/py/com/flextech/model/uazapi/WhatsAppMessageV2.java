package py.com.flextech.model.uazapi;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Getter
@Setter
public class WhatsAppMessageV2 {
    private String number;
    private String text;
    private Boolean linkPreview;
}