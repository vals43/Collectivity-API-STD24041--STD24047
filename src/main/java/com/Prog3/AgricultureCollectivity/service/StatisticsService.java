package com.Prog3.AgricultureCollectivity.service;

import com.Prog3.AgricultureCollectivity.entity.dto.CollectivityLocalStatistics;
import com.Prog3.AgricultureCollectivity.entity.dto.CollectivityOverallStatistics;
import com.Prog3.AgricultureCollectivity.exception.BadRequestException;
import com.Prog3.AgricultureCollectivity.exception.NotFoundException;
import com.Prog3.AgricultureCollectivity.repository.CollectivityRepository;
import com.Prog3.AgricultureCollectivity.repository.StatisticsRepository;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;

@Service
@AllArgsConstructor
public class StatisticsService {
    private final StatisticsRepository statisticsRepository;
    private final CollectivityRepository collectivityRepository;

    /**
     * Get local statistics for a specific collectivity
     * Includes: earned amount, unpaid amount, and assiduity percentage per member
     */
    public List<CollectivityLocalStatistics> getLocalStatistics(String collectivityId, Instant from, Instant to) {
        if (collectivityId == null || collectivityId.trim().isEmpty()) {
            throw new BadRequestException("Collectivity ID is required");
        }

        if (from == null || to == null) {
            throw new BadRequestException("Both 'from' and 'to' dates are required");
        }

        if (from.isAfter(to)) {
            throw new BadRequestException("'from' date must be before or equal to 'to' date");
        }

        // Verify collectivity exists
        if (collectivityRepository.findById(collectivityId) == null) {
            throw new NotFoundException("Collectivity not found with id: " + collectivityId);
        }

        return statisticsRepository.getLocalStatistics(collectivityId, from, to);
    }

    /**
     * Get overall statistics for all collectivities
     * Includes: current due percentage, new members, and overall assiduity percentage
     */
    public List<CollectivityOverallStatistics> getOverallStatistics(Instant from, Instant to) {
        if (from == null || to == null) {
            throw new BadRequestException("Both 'from' and 'to' dates are required");
        }

        if (from.isAfter(to)) {
            throw new BadRequestException("'from' date must be before or equal to 'to' date");
        }

        return statisticsRepository.getOverallStatistics(from, to);
    }
}