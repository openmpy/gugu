package com.openmpy.server.member.dto.request;

public record MemberLoginRequest(
    String phone,
    String password
) {

}
