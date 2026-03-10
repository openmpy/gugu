package com.openmpy.server.member.dto.request;

import java.util.List;

public record MemberDeleteImagesRequest(
    List<MemberDeleteImageRequest> images
) {

    public record MemberDeleteImageRequest(
        Long id,
        String key
    ) {

    }
}
