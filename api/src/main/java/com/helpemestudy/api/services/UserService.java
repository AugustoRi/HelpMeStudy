package com.helpemestudy.api.services;
import com.helpemestudy.api.entities.User;
import com.helpemestudy.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Optional<User> findByUsernameAndPassword(String name, String password) {
        Optional<User> findUser = userRepository.findByUsernameAndPassword(name, password);

        if (findUser.isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }

        return findUser;
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }
}

