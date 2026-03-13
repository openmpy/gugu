package com.openmpy.server.member.dto.request;

public record MemberActivateRequest(
    String nickname,
    Integer birthYear,
    String bio
) {

}
