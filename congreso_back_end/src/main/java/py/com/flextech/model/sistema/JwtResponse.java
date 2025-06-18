package py.com.flextech.model.sistema;




import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JwtResponse {

    private final String jwttoken;
    private final Usuario usuario;
    private final String timeOffSet;

}
