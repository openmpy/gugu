package com.openmpy.server.member.dto.response;

public record MemberRotateTokenResponse(
    String accessToken,
    String refreshToken
) {

}
