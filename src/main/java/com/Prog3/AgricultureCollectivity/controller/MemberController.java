package com.Prog3.AgricultureCollectivity.controller;

import com.Prog3.AgricultureCollectivity.entity.dto.CreateMember;
import com.Prog3.AgricultureCollectivity.entity.dto.CreateMemberPayment;
import com.Prog3.AgricultureCollectivity.entity.dto.MemberPaymentResponse;
import com.Prog3.AgricultureCollectivity.entity.dto.MemberResponse;
import com.Prog3.AgricultureCollectivity.exception.BadRequestException;
import com.Prog3.AgricultureCollectivity.exception.NotFoundException;
import com.Prog3.AgricultureCollectivity.service.MemberService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/members")
@AllArgsConstructor
public class MemberController {

    private final MemberService service;

    // Endpoints

    @PostMapping
    public ResponseEntity<?> createMember(@RequestBody List<CreateMember> members) {
        try {
            List<MemberResponse> createdMembers = service.createMembers(members);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdMembers);
        } catch (BadRequestException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        } catch (NotFoundException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Internal server error: " + ex.getMessage());
        }
    }

    @PostMapping("/{id}/payments")
    public ResponseEntity<?> createMemberPayments(
            @PathVariable String id,
            @RequestBody List<CreateMemberPayment> requests) {
        try {
            List<MemberPaymentResponse> responses = service.createPayments(id, requests);
            return ResponseEntity.status(HttpStatus.CREATED).body(responses);
        } catch (BadRequestException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (NotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An unexpected error occurred: " + e.getMessage());
        }
    }
}