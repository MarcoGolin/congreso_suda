package py.com.flextech.config.security;

import java.security.Key;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import py.com.flextech.model.sistema.Usuario;

@Service
public class JwtService {
	
	@Value("${token.signing.key}")
	private String jwtSigningKey;

	public String extractUserName(String token) {
		return extractClaim(token, Claims::getSubject);
	}

	public String generateToken(Usuario usuario, String timeOffSet) {
		Map<String, Object> extraClaims = new HashMap<>();
		extraClaims.put("idUsuario", usuario.getId());
		extraClaims.put("timeOffSet", timeOffSet);
		return generateToken(extraClaims, usuario);
	}

	public boolean isTokenValid(String token, UserDetails userDetails ) {
		final String userName = extractUserName(token);
		return (userName.equals(userDetails.getUsername())) && !isTokenExpired(token);
	}

	private <T> T extractClaim(String token, Function<Claims, T> claimsResolvers) {
		final Claims claims = extractAllClaims(token);
		return claimsResolvers.apply(claims);
	}

	private String generateToken(Map<String, Object> extraClaims, Usuario usuario) {
		LocalDateTime dtExpiration = LocalDateTime.now().plusMonths(1);
		return Jwts.builder().setClaims(extraClaims).setSubject(usuario.getEmail())
				.setIssuedAt(new Date(System.currentTimeMillis()))
				.setExpiration(Date.from(dtExpiration.atZone(ZoneId.systemDefault()).toInstant()))
				.signWith(getSigningKey(), SignatureAlgorithm.HS256).compact();
	}

	private boolean isTokenExpired(String token) {
		return extractExpiration(token).before(new Date());
	}

	private Date extractExpiration(String token) {
		return extractClaim(token, Claims::getExpiration);
	}

	public Claims extractAllClaims(String token) {
		return Jwts.parser().setSigningKey(getSigningKey()).parseClaimsJws(token).getBody();
	}

	private Key getSigningKey() {
		byte[] keyBytes = Decoders.BASE64.decode(jwtSigningKey);
		return Keys.hmacShaKeyFor(keyBytes);
	}
}