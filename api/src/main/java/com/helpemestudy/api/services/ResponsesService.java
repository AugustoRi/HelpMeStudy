package com.helpemestudy.api.services;

import com.helpemestudy.api.entities.Responses;
import com.helpemestudy.api.entities.User;
import com.helpemestudy.api.repositories.ResponsesRepository;
import com.helpemestudy.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ResponsesService {
    private final ResponsesRepository responsesRepository;
    private final UserRepository userRepository;

    @Autowired
    public ResponsesService(ResponsesRepository responsesRepository, UserRepository userRepository) {
        this.responsesRepository = responsesRepository;
        this.userRepository = userRepository;
    }

    public Responses saveResponse(Long userId, String content) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("Usuário não encontrado!");
        }
        Responses response = new Responses(userOpt.get(), content);
        return responsesRepository.save(response);
    }

    public List<Responses> getResponsesByUser(Long userId) {
        return responsesRepository.findByUserId(userId);
    }

    public Optional<Responses> getResponseById(Long id) {
        return responsesRepository.findById(id);
    }

    public void deleteResponse(Long id) {
        responsesRepository.deleteById(id);
    }

    public Optional<Responses> updateResponse(Long id, String newContent) {
        return responsesRepository.findById(id).map(response -> {
            response.setContent(newContent);
            return responsesRepository.save(response);
        });
    }
}
