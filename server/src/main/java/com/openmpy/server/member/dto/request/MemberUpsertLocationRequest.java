package com.openmpy.server.member.dto.request;

public record MemberUpsertLocationRequest(
    double longitude,
    double latitude
) {

}
