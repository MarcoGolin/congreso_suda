package py.com.flextech.dashboard.controller;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import py.com.flextech.dashboard.config.DashboardConfig;
import py.com.flextech.dashboard.dto.KpiDto;
import py.com.flextech.dashboard.dto.SeriesDto;
import py.com.flextech.dashboard.service.DashboardAdminService;

@RestController
@RequestMapping("/api/dashboard/admin/v1")
public class DashboardAdminController {

    private final DashboardAdminService service;
    private final DashboardConfig config;

    public DashboardAdminController(DashboardAdminService service, DashboardConfig config) {
        this.service = service;
        this.config = config;
    }

    @GetMapping("/meta")
    public ResponseEntity<Map<String, Boolean>> getMeta() {
        return ResponseEntity.ok(Collections.singletonMap("enabled", config.isEnabled()));
    }

    @GetMapping("/kpis/overview")
    public ResponseEntity<List<KpiDto>> getOverviewKpis(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (!config.isEnabled()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service.getOverviewKpis(date.toString()));
    }

    @GetMapping("/kpis/by-checkin-type")
    public ResponseEntity<List<KpiDto>> getKpisByCheckinType(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (!config.isEnabled()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service.getKpisByCheckinType(date.toString()));
    }

    @GetMapping("/series/hourly")
    public ResponseEntity<SeriesDto> getHourlySeries(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (!config.isEnabled()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service.getHourlySeries(date.toString()));
    }

    @GetMapping("/series/quarters")
    public ResponseEntity<SeriesDto> getQuarterlySeries(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (!config.isEnabled()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service.getQuarterlySeries(date.toString()));
    }

    @GetMapping("/tops/workshops")
    public ResponseEntity<List<KpiDto>> getTopWorkshops(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date, @RequestParam(defaultValue = "5") int limit) {
        if (!config.isEnabled()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service.getTopWorkshops(date.toString(), limit));
    }

    @GetMapping("/noshow")
    public ResponseEntity<List<Map<String, Object>>> getNoShows(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (!config.isEnabled()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service.getNoShows(date.toString()));
    }
}
