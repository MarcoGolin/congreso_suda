package py.com.flextech.controller.systema;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import py.com.flextech.config.security.AuthenticationService;
import py.com.flextech.model.sistema.JwtRequest;

@RestController
@CrossOrigin
@RequestMapping({ "/api/auth" })
@RequiredArgsConstructor
public class AuthController {

	private final AuthenticationService authService;

	@PostMapping("/authenticate")
	public ResponseEntity<?> signin(@RequestBody JwtRequest request) {
		return authService.signin(request);
	}
}
