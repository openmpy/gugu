package com.openmpy.server.member.domain.entity;

import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.constants.MemberStatus;
import com.openmpy.server.member.domain.vo.MemberBirthYear;
import com.openmpy.server.member.domain.vo.MemberComment;
import com.openmpy.server.member.domain.vo.MemberNickname;
import com.openmpy.server.member.domain.vo.MemberPhone;
import jakarta.persistence.AttributeOverride;
import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.SQLRestriction;
import org.locationtech.jts.geom.Point;

@Getter
@Builder(access = AccessLevel.PRIVATE)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@SQLRestriction("status = 'ACTIVE'")
@Entity
public class Member {

    private static final String DEFAULT_BUMP_MESSAGE = "반갑습니다.";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "phone", nullable = false, unique = true))
    private MemberPhone phone;

    @Column(name = "password", nullable = false)
    private String password;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "nickname", unique = true))
    private MemberNickname nickname;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "birth_year"))
    private MemberBirthYear birthYear;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender")
    private MemberGender gender;

    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "comment"))
    private MemberComment comment;

    @Column(name = "location", columnDefinition = "geography(Point,4326)")
    private Point location;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private MemberStatus status;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    public static Member create(
        final String phone,
        final String password,
        final MemberGender gender
    ) {
        final String randomNickname = UUID.randomUUID()
            .toString()
            .replace("-", "")
            .substring(0, 10);

        return Member.builder()
            .phone(new MemberPhone(phone))
            .password(password)
            .nickname(new MemberNickname(randomNickname))
            .birthYear(new MemberBirthYear(2000))
            .gender(gender)
            .status(MemberStatus.ACTIVE)
            .createdAt(LocalDateTime.now())
            .build();
    }

    public void activate(
        final String nickname,
        final Integer birthYear,
        final String bio
    ) {
        this.nickname = new MemberNickname(nickname);
        this.birthYear = new MemberBirthYear(birthYear);
        this.status = MemberStatus.ACTIVE;
        this.bio = bio;
        this.updatedAt = LocalDateTime.now();
    }

    public void update(
        final String nickname,
        final Integer birthYear
    ) {
        this.nickname = new MemberNickname(nickname);
        this.birthYear = new MemberBirthYear(birthYear);
        this.updatedAt = LocalDateTime.now();
    }

    public void updateLocation(final Point location) {
        this.location = location;
        this.updatedAt = LocalDateTime.now();
    }

    public void writeComment(final String comment) {
        this.comment = new MemberComment(comment);
        this.updatedAt = LocalDateTime.now();
    }

    public void bumpComment() {
        if (this.comment == null) {
            this.comment = new MemberComment(DEFAULT_BUMP_MESSAGE);
        }

        this.updatedAt = LocalDateTime.now();
    }

    public void delete() {
        if (this.status == MemberStatus.DELETED) {
            throw new IllegalArgumentException("이미 삭제된 계정입니다.");
        }

        this.status = MemberStatus.DELETED;
        this.deletedAt = LocalDateTime.now();
    }

    public String getPhone() {
        return phone.getValue();
    }

    public String getNickname() {
        return nickname.getValue();
    }

    public Integer getBirthYear() {
        return birthYear.getValue();
    }

    public String getComment() {
        return comment.getValue();
    }
}
