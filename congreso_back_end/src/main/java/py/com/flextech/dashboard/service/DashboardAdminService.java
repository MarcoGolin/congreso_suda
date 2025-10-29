package py.com.flextech.dashboard.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import py.com.flextech.dashboard.dto.KpiDto;
import py.com.flextech.dashboard.dto.SeriesDto;
import py.com.flextech.mapper.dashboard.DashboardAdminMapper;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class DashboardAdminService {

    private final DashboardAdminMapper mapper;


    public List<KpiDto> getOverviewKpis(String date) {
        List<KpiDto> kpis = new ArrayList<>();
        String startOfDay = date + " 00:00:00";
        String endOfDay = date + " 23:59:59";
        String noon = date + " 12:00:00";

        long uniqueCheckins = mapper.countUniqueCheckinsToday(startOfDay, endOfDay);
        long confirmedParticipants = mapper.countConfirmedParticipants();
        double attendanceRate = (confirmedParticipants > 0) ? ((double) uniqueCheckins / confirmedParticipants) * 100 : 0;
        kpis.add(new KpiDto("Asistencia (%)", String.format("%.2f", attendanceRate)));
        kpis.add(new KpiDto("Check-ins (Mañana)", mapper.countMorningCheckins(startOfDay, noon)));
        kpis.add(new KpiDto("Check-ins (Tarde)", mapper.countAfternoonCheckins(noon, endOfDay)));
        return kpis;
    }

    public List<KpiDto> getKpisByCheckinType(String date) {
        String startOfDay = date + " 00:00:00";
        String endOfDay = date + " 23:59:59";
        return mapper.countByCheckinType(startOfDay, endOfDay).stream()
                .map(result -> new KpiDto((String) result.get("tipo"), result.get("count")))
                .collect(Collectors.toList());
    }

    public SeriesDto getHourlySeries(String date) {
        String startOfDay = date + " 00:00:00";
        String endOfDay = date + " 23:59:59";
        List<Map<String, Object>> results = mapper.countHourlyCheckins(startOfDay, endOfDay);
        List<String> labels = results.stream().map(result -> result.get("hour").toString()).collect(Collectors.toList());
        List<Object> values = results.stream().map(result -> result.get("count")).collect(Collectors.toList());
        Map<String, Object> seriesMap = new HashMap<>();
        seriesMap.put("name", "Check-ins");
        seriesMap.put("data", values);
        List<Map<String, Object>> series = new ArrayList<>();
        series.add(seriesMap);
        return new SeriesDto(labels, series);
    }

    public SeriesDto getQuarterlySeries(String date) {
        String startOfDay = date + " 00:00:00";
        String endOfDay = date + " 23:59:59";
        List<Map<String, Object>> results = mapper.countQuarterlyCheckins(startOfDay, endOfDay);
        List<String> labels = results.stream().map(result -> (String) result.get("slot")).collect(Collectors.toList());
        List<Object> values = results.stream().map(result -> result.get("count")).collect(Collectors.toList());
        Map<String, Object> seriesMap = new HashMap<>();
        seriesMap.put("name", "Check-ins");
        seriesMap.put("data", values);
        List<Map<String, Object>> series = new ArrayList<>();
        series.add(seriesMap);
        return new SeriesDto(labels, series);
    }

    public List<KpiDto> getTopWorkshops(String date, int limit) {
        String startOfDay = date + " 00:00:00";
        String endOfDay = date + " 23:59:59";
        return mapper.findTopWorkshops(startOfDay, endOfDay, limit).stream()
                .map(result -> new KpiDto((String) result.get("titulo"), result.get("count")))
                .collect(Collectors.toList());
    }

    public List<Map<String, Object>> getNoShows(String date) {
        String startOfDay = date + " 00:00:00";
        String endOfDay = date + " 23:59:59";
        return mapper.findNoShows(startOfDay, endOfDay);
    }
}
