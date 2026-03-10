package com.openmpy.server.member.presentation;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.member.application.MemberImageService;
import com.openmpy.server.member.dto.request.MemberDeleteImagesRequest;
import com.openmpy.server.member.dto.request.MemberSaveImagesRequest;
import com.openmpy.server.member.dto.request.PresignedImagesRequest;
import com.openmpy.server.member.dto.response.PresignedImagesResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/api/v1")
@RestController
public class MemberImageController {

    private final MemberImageService memberImageService;

    @PostMapping("/members/images/presigned")
    public ResponseEntity<PresignedImagesResponse> presignedImages(
        @Login final Long memberId,
        @RequestBody final PresignedImagesRequest request
    ) {
        final PresignedImagesResponse response = memberImageService.createPresignedUrls(
            memberId,
            request
        );

        return ResponseEntity.ok(response);
    }

    @PostMapping("/members/images")
    public ResponseEntity<Void> saveImages(
        @Login final Long memberId,
        @RequestBody final MemberSaveImagesRequest request
    ) {
        memberImageService.saveImages(memberId, request);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/members/images")
    public ResponseEntity<Void> deleteImages(
        @Login final Long memberId,
        @RequestBody final MemberDeleteImagesRequest request
    ) {
        memberImageService.deleteImages(memberId, request);
        return ResponseEntity.noContent().build();
    }
}
