package com.openmpy.server.member.dto.response;

public record MemberVerifyCodeResponse(
    String accessToken,
    String refreshToken
) {

}
