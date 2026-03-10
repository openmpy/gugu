package com.openmpy.server.member.application;

import com.openmpy.server.global.properties.S3Properties;
import com.openmpy.server.member.domain.constants.MemberImageType;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.entity.MemberImage;
import com.openmpy.server.member.dto.request.MemberDeleteImagesRequest;
import com.openmpy.server.member.dto.request.MemberSaveImagesRequest;
import com.openmpy.server.member.dto.request.PresignedImagesRequest;
import com.openmpy.server.member.dto.response.PresignedImagesResponse;
import com.openmpy.server.member.dto.response.PresignedImagesResponse.PresignedImageResponse;
import com.openmpy.server.member.repository.MemberImageRepository;
import com.openmpy.server.member.repository.MemberRepository;
import com.openmpy.server.s3.application.S3Service;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberImageService {

    private final MemberImageRepository memberImageRepository;
    private final MemberRepository memberRepository;

    private final S3Properties s3Properties;
    private final S3Service s3Service;

    public PresignedImagesResponse createPresignedUrls(
        final Long memberId,
        final PresignedImagesRequest request
    ) {
        final List<PresignedImageResponse> responses = request.images().stream()
            .map(it -> {
                final String extension = convertExtension(it.contentType());
                final String key = generateKey(memberId, it.type(), extension);
                final String presignedUrl = s3Service.createPresignedUrl(key, it.contentType());

                return new PresignedImageResponse(key, presignedUrl);
            })
            .toList();

        return new PresignedImagesResponse(responses);
    }

    @Transactional
    public void saveImages(final Long memberId, final MemberSaveImagesRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);

        request.images().forEach(it -> {
            final MemberImage memberImage = MemberImage.create(
                s3Properties.endpoint() + it.key(),
                it.type(),
                it.order(),
                member
            );

            memberImageRepository.save(memberImage);
        });
    }

    @Transactional
    public void deleteImages(final Long memberId, final MemberDeleteImagesRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);

        request.images().forEach(it -> {
            final MemberImage memberImage = memberImageRepository.findByIdAndMember(
                it.id(),
                member
            ).orElseThrow(() -> new IllegalArgumentException("회원 이미지를 찾을 수 없습니다."));

            memberImageRepository.delete(memberImage);
            s3Service.deleteImage(it.key());
        });
    }

    private String generateKey(
        final Long memberId,
        final MemberImageType type,
        final String extension
    ) {
        return "members/" + memberId + "/"
            + type.name().toLowerCase() + "/"
            + UUID.randomUUID() + "." + extension;
    }

    private String convertExtension(final String contentType) {
        return switch (contentType) {
            case "image/jpeg" -> "jpg";
            case "image/png" -> "png";
            case "image/webp" -> "webp";
            default -> throw new IllegalArgumentException(
                "지원하지 않는 이미지 타입입니다."
            );
        };
    }
}
