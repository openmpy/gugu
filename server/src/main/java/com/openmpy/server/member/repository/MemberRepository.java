package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.vo.MemberPhone;
import com.openmpy.server.member.repository.projection.MemberWithDistanceProjection;
import io.lettuce.core.dynamic.annotation.Param;
import java.util.List;
import java.util.Optional;
import org.locationtech.jts.geom.Point;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface MemberRepository extends JpaRepository<Member, Long> {

    Optional<Member> findByPhone(final MemberPhone phone);

    boolean existsByPhone_Value(final String value);

    boolean existsByNickname_Value(final String value);

    @Query(
        value = """
                SELECT m
                FROM Member m
                WHERE m.id <> :id
                  AND m.comment IS NOT NULL
                  AND (:cursorId IS NULL OR m.id < :cursorId)
                ORDER BY m.updatedAt DESC
            """
    )
    List<Member> findAllByIdWithoutDistance(
        @Param("id") final Long id,
        @Param("cursorId") final Long cursorId,
        final Pageable pageable
    );

    @Query(
        value = """
                SELECT m
                FROM Member m
                WHERE m.id <> :id
                  AND m.gender = :gender
                  AND m.comment IS NOT NULL
                  AND (:cursorId IS NULL OR m.id < :cursorId)
                ORDER BY m.updatedAt DESC
            """
    )
    List<Member> findAllByIdAndGenderWithoutDistance(
        @Param("id") final Long id,
        @Param("gender") final MemberGender gender,
        @Param("cursorId") final Long cursorId,
        final Pageable pageable
    );

    @Query(value = """
            SELECT m.id as id,
                  m.nickname as nickname,
                  m.gender as gender,
                  m.birth_year as birthYear,
                  ST_Distance(m.location::geography, :location)/1000 as distance,
                  m.comment as comment,
                  m.updated_at as updatedAt
            FROM member m
            WHERE m.id <> :id
              AND m.comment IS NOT NULL
              AND (:cursorId IS NULL OR m.id < :cursorId)
            ORDER BY m.updated_at DESC, distance
        """,
        nativeQuery = true
    )
    List<MemberWithDistanceProjection> findAllByIdWithDistance(
        @Param("id") final Long id,
        @Param("location") final Point location,
        @Param("cursorId") final Long cursorId,
        final Pageable pageable
    );

    @Query(value = """
            SELECT m.id as id,
                  m.nickname as nickname,
                  m.gender as gender,
                  m.birth_year as birthYear,
                  ST_Distance(m.location::geography, :location)/1000 as distance,
                  m.comment as comment,
                  m.updated_at as updatedAt
            FROM member m
            WHERE m.id <> :id
                AND m.gender = :gender
                AND m.comment IS NOT NULL
                AND (:cursorId IS NULL OR m.id < :cursorId)
            ORDER BY m.updated_at DESC, distance
        """,
        nativeQuery = true
    )
    List<MemberWithDistanceProjection> findAllByIdAndGenderWithDistance(
        @Param("id") final Long id,
        @Param("location") final Point location,
        @Param("gender") final String gender,
        @Param("cursorId") final Long cursorId,
        final Pageable pageable
    );
}
