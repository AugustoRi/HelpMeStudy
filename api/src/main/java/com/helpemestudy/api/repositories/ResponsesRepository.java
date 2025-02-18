package com.helpemestudy.api.repositories;

import com.helpemestudy.api.entities.Responses;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ResponsesRepository extends JpaRepository<Responses, Long> {
    List<Responses> findByUserId(Long userId);
}
