package com.helpemestudy.api.dtos;

import com.helpemestudy.api.enums.UserRole;

public record RegisterDTO(String username, String password, UserRole role) {
}
