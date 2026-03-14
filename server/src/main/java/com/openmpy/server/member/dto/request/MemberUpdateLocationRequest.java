package com.openmpy.server.member.dto.request;

public record MemberUpdateLocationRequest(
    Double latitude,
    Double longitude
) {

}
