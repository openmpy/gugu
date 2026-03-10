package com.openmpy.server.global.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("aws.s3")
public record S3Properties(
    String bucket,
    String endpoint,
    String region,
    String accessKey,
    String secretKey
) {

}
