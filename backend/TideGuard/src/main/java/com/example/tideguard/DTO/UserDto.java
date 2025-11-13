package com.example.tideguard.DTO;


import com.example.tideguard.Models.User;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    @JsonProperty("userId")
    private Long id;
    @JsonProperty("firstName")
    private String firstname;
    @JsonProperty("lastName")
    private String lastname;
    private String email;
    private String city;

    public static UserDto from(User user) {
        return UserDto.builder()
                .id(user.getUserId())
                .firstname(user.getFirstName())
                .lastname(user.getLastName())
                .email(user.getEmail())
                .city(user.getCity())
                .build();
    }

    public static List<UserDto> userDtoList(List<User> users) {
        return users.stream()
                .map(UserDto::from)
                .collect(Collectors.toList());
    }
}
