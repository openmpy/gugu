package com.openmpy.server.member.dto.request;

import com.openmpy.server.member.domain.constants.MemberImageType;
import java.util.List;

public record PresignedImagesRequest(
    List<PresignedImageRequest> images
) {

    public record PresignedImageRequest(
        MemberImageType type,
        String contentType
    ) {

    }
}
