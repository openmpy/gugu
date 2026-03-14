package com.openmpy.server.member.domain.entity;

import com.openmpy.server.member.domain.vo.MemberCommentContent;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
public class MemberComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "content", nullable = false)
    private MemberCommentContent content;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public static MemberComment create(final Member member, final String content) {
        return MemberComment.builder()
            .member(member)
            .content(new MemberCommentContent(content))
            .updatedAt(LocalDateTime.now())
            .build();
    }

    public String getContent() {
        return content.getValue();
    }
}
