package com.openmpy.server.member.dto.response;

import java.util.List;

public record PresignedImagesResponse(
    List<PresignedImageResponse> images
) {

    public record PresignedImageResponse(
        String key,
        String uploadUrl
    ) {

    }
}
