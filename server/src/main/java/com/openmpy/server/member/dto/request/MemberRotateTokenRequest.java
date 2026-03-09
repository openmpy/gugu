package com.openmpy.server.member.dto.request;

public record MemberRotateTokenRequest(
    String accessToken,
    String refreshToken
) {

}
