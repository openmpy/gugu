package com.openmpy.server.global.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("aws.s3")
public record S3Properties(
    String region,
    String bucket,
    String accessKey,
    String secretKey
) {

}
