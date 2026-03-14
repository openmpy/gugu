package com.openmpy.server.global.dto;

import java.util.List;

public record CursorResponse<T>(
    List<T> payload,
    Long nextId,
    boolean hasNext
) {

}
