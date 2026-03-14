package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.vo.MemberPhone;
import com.openmpy.server.member.repository.projection.MemberGetCommentProjection;
import java.util.List;
import java.util.Optional;
import org.locationtech.jts.geom.Point;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface MemberRepository extends JpaRepository<Member, Long> {

    Optional<Member> findByPhone(final MemberPhone phone);

    boolean existsByPhone_Value(final String value);

    boolean existsByNickname_Value(final String value);

    @Query(
        value = """
                SELECT 
                    m.id,
                    m.nickname,
                    m.gender,
                    m.birth_year,
                    CASE WHEN :location IS NOT NULL
                         THEN ST_Distance(m.location::geography, :location)/1000
                    END AS distance,
                    m.comment,
                    m.updated_at
                FROM member m
                WHERE m.id <> :id
                  AND m.comment IS NOT NULL
                  AND (:gender IS NULL OR :gender = 'ALL' OR m.gender = :gender)
                  AND (:cursorId IS NULL OR m.id < :cursorId)
                ORDER BY m.updated_at DESC, distance
                LIMIT :size
            """,
        nativeQuery = true
    )
    List<MemberGetCommentProjection> findMembersWithDistance(
        @Param("id") final Long id,
        @Param("gender") final String gender,
        @Param("location") final Point location,
        @Param("cursorId") final Long cursorId,
        @Param("size") final int size
    );
}
