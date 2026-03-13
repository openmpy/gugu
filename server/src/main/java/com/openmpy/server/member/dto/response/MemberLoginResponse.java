package com.openmpy.server.member.dto.response;

public record MemberLoginResponse(
    String accessToken,
    String refreshToken
) {

}
