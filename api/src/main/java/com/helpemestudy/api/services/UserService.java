package com.helpemestudy.api.services;
import com.helpemestudy.api.entities.User;
import com.helpemestudy.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public Optional<User> findByUsernameAndPassword(String name, String password) {
        Optional<User> findUser = userRepository.findByUsernameAndPassword(name, password);

        if (findUser.isEmpty()) {
            throw new RuntimeException("User not found");
        }

        return findUser;
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }
}

