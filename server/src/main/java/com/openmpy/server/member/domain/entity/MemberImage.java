package com.openmpy.server.member.domain.entity;

import com.openmpy.server.member.domain.constants.MemberImageType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder(access = AccessLevel.PRIVATE)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
public class MemberImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private MemberImageType type;

    @Column(name = "image_order", nullable = false)
    private Integer imageOrder;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    public static MemberImage create(
        final String imageUrl,
        final MemberImageType type,
        final Integer imageOrder,
        final Member member
    ) {
        if (imageOrder < 0 || imageOrder > 9) {
            throw new IllegalArgumentException("이미지 순서는 0부터 9까지 가능합니다.");
        }

        return MemberImage.builder()
            .imageUrl(imageUrl)
            .type(type)
            .imageOrder(imageOrder)
            .createdAt(LocalDateTime.now())
            .member(member)
            .build();
    }
}
