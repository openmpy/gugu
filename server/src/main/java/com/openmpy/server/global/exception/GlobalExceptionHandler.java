package com.openmpy.server.global.exception;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<ErrorResponse> customException(
        final CustomException e,
        final HttpServletRequest servletRequest
    ) {
        log.warn("custom exception method = {}, uri = {}, message = {}",
            servletRequest.getMethod(),
            servletRequest.getRequestURI(),
            e.getMessage()
        );
        return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ErrorResponse> httpRequestMethodNotSupportedException(
        final HttpRequestMethodNotSupportedException e
    ) {
        log.warn(e.getMessage());
        return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ErrorResponse> noResourceException(final NoResourceFoundException e) {
        log.warn(e.getMessage());
        return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> httpMessageNotReadableException(
        final HttpMessageNotReadableException e) {
        log.warn(e.getMessage());
        return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(
        final IllegalArgumentException e) {
        log.warn(e.getMessage());
        return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
    }

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ErrorResponse> responseStatusException(final ResponseStatusException e) {
        log.warn(e.getMessage());
        return ResponseEntity.status(e.getStatusCode()).body(new ErrorResponse(e.getReason()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> exception(
        final Exception e,
        final HttpServletRequest servletRequest
    ) {
        log.error("exception method = {}, uri = {}, message = {}",
            servletRequest.getMethod(),
            servletRequest.getRequestURI(),
            e.getMessage()
        );
        return ResponseEntity.internalServerError().body(new ErrorResponse(e.getMessage()));
    }
}
