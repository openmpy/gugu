package com.openmpy.server.member.dto.response;

public record MemberSignupResponse(
    String accessToken,
    String refreshToken
) {

}
