package com.openmpy.server.member.dto.request;

import com.openmpy.server.member.domain.constants.MemberImageType;
import java.util.List;

public record MemberSaveImagesRequest(
    List<MemberSaveImageRequest> images
) {

    public record MemberSaveImageRequest(
        String key,
        MemberImageType type,
        Integer order
    ) {

    }
}
