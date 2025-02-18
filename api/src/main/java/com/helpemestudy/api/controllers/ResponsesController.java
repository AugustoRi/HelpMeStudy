package com.helpemestudy.api.controllers;

import com.helpemestudy.api.dtos.ResponsesDTO;
import com.helpemestudy.api.entities.Responses;
import com.helpemestudy.api.services.ResponsesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PutMapping;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users/{userId}/responses")
public class ResponsesController {

    private final ResponsesService responsesService;

    @Autowired
    public ResponsesController(ResponsesService responsesService) {
        this.responsesService = responsesService;
    }

    @PostMapping()
    public ResponseEntity<Responses> createResponse(@PathVariable String userId, @RequestBody @Validated ResponsesDTO responsesDTO) {
        Responses savedResponse = responsesService.saveResponse(Long.valueOf(userId), responsesDTO.content());
        return ResponseEntity.ok(savedResponse);
    }

    @GetMapping()
    public ResponseEntity<List<Responses>> getResponsesByUser(@PathVariable String userId) {
        return ResponseEntity.ok(responsesService.getResponsesByUser(Long.valueOf(userId)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Responses> getResponseById(@PathVariable Long id) {
        Optional<Responses> response = responsesService.getResponseById(id);
        return response.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteResponse(@PathVariable Long id) {
        responsesService.deleteResponse(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Responses> updateResponse(@PathVariable Long id,  @RequestBody @Validated ResponsesDTO responsesDTO) {
        return responsesService.updateResponse(id, responsesDTO.content())
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
