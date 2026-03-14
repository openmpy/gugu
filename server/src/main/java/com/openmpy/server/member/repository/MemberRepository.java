package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.vo.MemberPhone;
import java.util.List;
import java.util.Optional;
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
    List<Member> findAllByIdWithCursor(
        final Long id,
        final Long cursorId,
        final Pageable pageable
    );
}
