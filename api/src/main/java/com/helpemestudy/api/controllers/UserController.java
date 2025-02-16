package com.helpemestudy.api.controllers;

import com.helpemestudy.api.dtos.AuthenticationDTO;
import com.helpemestudy.api.dtos.RegisterDTO;
import com.helpemestudy.api.entities.LoginResponseDTO;
import com.helpemestudy.api.entities.User;
import com.helpemestudy.api.services.TokenService;
import com.helpemestudy.api.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@RestController
@RequestMapping("api/users")
public class UserController {
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final TokenService tokenService;

    @Autowired
    public UserController(UserService userService, AuthenticationManager authenticationManager, TokenService tokenService) {
        this.userService = userService;
        this.authenticationManager = authenticationManager;
        this.tokenService = tokenService;
    }

    @PostMapping("/auth/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody @Validated AuthenticationDTO data) {
        var usernamePassword = new UsernamePasswordAuthenticationToken(data.username(), data.password());
        var auth = this.authenticationManager.authenticate(usernamePassword);

        var token = tokenService.generateToken((User) auth.getPrincipal());

        return ResponseEntity.ok(new LoginResponseDTO(token));
    }

    @PostMapping("/auth/register")
    public ResponseEntity<User> register(@RequestBody @Validated RegisterDTO data) {
        if (this.userService.loadUserByUsername(data.username()) != null) return ResponseEntity.badRequest().build();

        var encryptedPassword = new BCryptPasswordEncoder().encode(data.password());
        var newUser = new User(data.username(), encryptedPassword, data.role());

        this.userService.saveUser(newUser);

        return ResponseEntity.ok().build();
    }

    @PutMapping("/auth/update/{id}")
    public ResponseEntity<User> updateUser(@PathVariable String id, @RequestBody @Validated RegisterDTO data) {
        User existingUser = userService.getUserById(Long.valueOf(id));

        if (existingUser == null) {
            return ResponseEntity.notFound().build();
        }

        existingUser.setUsername(data.username());
        existingUser.setPassword(new BCryptPasswordEncoder().encode(data.password()));
        existingUser.setRole(data.role());

        User updatedUser = userService.saveUser(existingUser);
        return ResponseEntity.ok(updatedUser);
    }

    @GetMapping
    public List<User> getUsers() {
        return userService.getAll();
    }

}

