package com.openmpy.server.member.domain.entity;

import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.constants.MemberStatus;
import com.openmpy.server.member.domain.vo.MemberBirthYear;
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
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.SQLRestriction;

@Getter
@Builder(access = AccessLevel.PRIVATE)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@SQLRestriction("status IN ('PENDING', 'ACTIVE')")
@Entity
public class Member {

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

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private MemberStatus status;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    public static Member create(final String phone, final String password) {
        return Member.builder()
            .phone(new MemberPhone(phone))
            .password(password)
            .status(MemberStatus.PENDING)
            .createdAt(LocalDateTime.now())
            .build();
    }

    public void activate(
        final String nickname,
        final Integer birthYear,
        final MemberGender gender,
        final String bio
    ) {
        this.nickname = new MemberNickname(nickname);
        this.birthYear = new MemberBirthYear(birthYear);
        this.gender = gender;
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
}
