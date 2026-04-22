package com.collectivity.agricultural.service;

import com.collectivity.agricultural.model.Collectivity;
import com.collectivity.agricultural.model.dto.CollectivityResponse;
import com.collectivity.agricultural.model.dto.CreateCollectivity;
import com.collectivity.agricultural.repository.CollectivityRepository;
import com.collectivity.agricultural.validator.CollectivityValidator;
import lombok.AllArgsConstructor;
import org.apache.coyote.BadRequestException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@AllArgsConstructor
public class CollectivityService {
    @Autowired
    private final CollectivityRepository repository;
    private final CollectivityValidator validator;

    // J question
    public Collectivity assignIdentity(Integer id, String newNumber, String newName) {
        // Récupération de l'état actuel
        Collectivity collectivity = repository.findById(id);
        if (collectivity == null) {
            throw new RuntimeException("Collectivité introuvable ID: " + id);
        }

        if (collectivity.getNumber() != null || collectivity.getName() != null) {
            // Cette exception doit retourner un 403 (Forbidden)
            throw new IllegalStateException("L'identité est déjà fixée et ne peut plus être modifiée.");
        }

        if (repository.existsByName(newName)) {
            // Cette exception doit retourner un 400 (Bad Request)
            throw new IllegalArgumentException("Le nom '" + newName + "' est déjà utilisé.");
        }

        repository.updateIdentity(id, newNumber, newName);

        return repository.findById(id);
    }

    public List<CollectivityResponse> createCollectivities(List<CreateCollectivity> createCollectivities) throws BadRequestException {
        List<Collectivity> collectivitiesToSave = new ArrayList<>();
        List<List<Integer>> memberIdsList = new ArrayList<>();
        List<Integer> presidentIds = new ArrayList<>();
        List<Integer> vicePresidentIds = new ArrayList<>();
        List<Integer> treasurerIds = new ArrayList<>();
        List<Integer> secretaryIds = new ArrayList<>();

        for (CreateCollectivity request : createCollectivities) {
            validator.validateCollectivityCreation(request);

            Collectivity collectivity = Collectivity.builder()
                    .number(generateCollectivityNumber())
                    .name(generateCollectivityName(request.getLocation()))
                    .speciality("Agriculture")
                    .federationApproval(request.isFederationApproval())
                    .authorizationDate(Date.from(Instant.now()))
                    .location(request.getLocation())
                    .build();

            collectivitiesToSave.add(collectivity);
            memberIdsList.add(request.getMemberIds());
            presidentIds.add(request.getStructure().getPresidentId());
            vicePresidentIds.add(request.getStructure().getVicePresidentId());
            treasurerIds.add(request.getStructure().getTreasurerId());
            secretaryIds.add(request.getStructure().getSecretaryId());
        }

        List<Collectivity> savedCollectivities = repository.saveAll(
                collectivitiesToSave,
                memberIdsList,
                presidentIds,
                vicePresidentIds,
                treasurerIds,
                secretaryIds
        );

        return savedCollectivities.stream()
                .map(this::buildResponse)
                .toList();
    }

    private CollectivityResponse buildResponse(Collectivity collectivity) {
        return CollectivityResponse.builder()
                .id(String.valueOf(collectivity.getId()))
                .location(collectivity.getLocation())
                .structure(collectivity.getStructure())
                .members(collectivity.getMembers())
                .build();
    }

    private String generateCollectivityNumber() {
        return "COL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    private String generateCollectivityName(String locationName) {
        return "Collectivité de " + locationName;
    }
}