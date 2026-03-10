package com.openmpy.server.s3.application;

import com.openmpy.server.global.properties.S3Properties;
import java.time.Duration;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;

@RequiredArgsConstructor
@Service
public class S3Service {

    private final S3Presigner s3Presigner;
    private final S3Properties s3Properties;

    public String createPresignedUrl(final String key, final String contentType) {
        final PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
            .signatureDuration(Duration.ofMinutes(5))
            .putObjectRequest(r -> r
                .bucket(s3Properties.bucket())
                .key(key)
                .contentType(contentType)
            )
            .build();
        final PresignedPutObjectRequest presignedPutObject = s3Presigner.presignPutObject(
            presignRequest
        );

        return presignedPutObject.url().toString();
    }
}
