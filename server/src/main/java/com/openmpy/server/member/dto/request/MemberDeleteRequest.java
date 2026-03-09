package com.openmpy.server.member.dto.request;

public record MemberDeleteRequest(
    String accessToken,
    String refreshToken
) {

}
