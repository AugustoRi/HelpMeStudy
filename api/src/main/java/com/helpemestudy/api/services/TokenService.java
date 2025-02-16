package com.helpemestudy.api.services;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.helpemestudy.api.entities.User;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Service
public class TokenService {

    public String generateToken(User user) {
        try {
            String secret = "my-secret-key";
            Algorithm algorithm = Algorithm.HMAC256(secret);
            return JWT.create()
                    .withIssuer("auth-api")
                    .withSubject(user.getUsername())
                    .withClaim("userId", user.getId().toString())
                    .withExpiresAt(generateExpirationDate())
                    .sign(algorithm);
        } catch (JWTCreationException jwtCreationException) {
            throw new RuntimeException("Error while generate token", jwtCreationException);
        }
    }

    public String validateToken(String token) {
        try {
            String secret = "my-secret-key";
            Algorithm algorithm = Algorithm.HMAC256(secret);
            return JWT.require(algorithm)
                    .withIssuer("auth-api")
                    .build()
                    .verify(token)
                    .getSubject();
        } catch (JWTCreationException jwtCreationException) {
            return "";
        }
    }

    private Instant generateExpirationDate() {
        var brasiliaTimezone = "-03:00";
        return LocalDateTime.now().plusHours(2).toInstant(ZoneOffset.of(brasiliaTimezone));
    }
}
